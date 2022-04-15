import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tensorflow/home.dart';

List<CameraDescription>? cameras;
// https://teachablemachine.withgoogle.com/train/tiny_image
void main() async{
  await WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home:Scaffold(),
      home: Home(),
    );
  }
}
