import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FaceDetectionDetailScreen extends StatefulWidget {
  FaceDetectionDetailScreen({super.key, required this.file});
  XFile? file;
  @override
  State<FaceDetectionDetailScreen> createState() =>
      _FaceDetectionDetailScreenState();
}

class _FaceDetectionDetailScreenState extends State<FaceDetectionDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Detection'),
      ),
    );
  }
}
