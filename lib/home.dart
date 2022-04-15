import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tensorflow/main.dart';
import 'package:tflite/tflite.dart';
// https://teachablemachine.withgoogle.com/train/tiny_image
class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CameraImage? cameraImage;
  CameraController? cameraController;
  String output = '';

  loadcamera() {
    cameraController = CameraController(cameras![0], ResolutionPreset.medium);
    cameraController!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraController!.startImageStream((image) => setState(() {
              cameraImage = image;
              runModel();
            }));
      });
    });
  }

  runModel() async {
    if (cameraImage != null) {
      var predictions = await Tflite.runModelOnFrame(
        bytesList: cameraImage!.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: cameraImage!.height,
        imageWidth: cameraImage!.width,
        numResults: 2,
        rotation: 90,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5,
        asynch: true,
      );

      predictions!.forEach((element) {
        setState(() {
          output = element['label'];
          print(output.toString());
        });
      });
    }
  }

  loadmodel() async {
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadcamera();
    loadmodel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            // child: AspectRatio(
            //   aspectRatio: cameraController!.value.aspectRatio,
            //   child: CameraPreview(cameraController!),
            // ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: !cameraController!.value.isInitialized
                  ? Container()
                  : AspectRatio(
                      aspectRatio: cameraController!.value.aspectRatio,
                      child: CameraPreview(cameraController!),
                    ),
            ),
          ),
          Container(
            child: Text(
              output.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
