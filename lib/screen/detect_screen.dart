import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'dart:ui' as ui;
import '../face_painter.dart';

class DetectScreen extends StatefulWidget {
  const DetectScreen({super.key, this.path = ""});
  final String path;

  @override
  State<DetectScreen> createState() => _DetectScreenState();
}

class _DetectScreenState extends State<DetectScreen> {
  List<Face>? faces;
  InputImage? inputImage;
  ui.Image? image;

  @override
  void initState() {
    inputImage = InputImage.fromFilePath(widget.path);
    detectFaces();
    super.initState();
  }

  void detectFaces() async {
    loadImage(widget.path);
    final faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true,
        enableContours: true,
        enableLandmarks: true,
        enableTracking: true,
        performanceMode: FaceDetectorMode.accurate,
      ),
    );
    var detectFaces = await faceDetector.processImage(inputImage!);
    setState(() {
      faces = detectFaces;
    });
  }

  void loadImage(String path) async {
    final Uint8List data = await File(path).readAsBytes();
    await decodeImageFromList(data).then((value) {
      setState(() {
        image = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var isSmilling = faces != null
        ? faces!
            .where((element) =>
                element.smilingProbability != null &&
                element.smilingProbability! > 0.4)
            .length
        : 0;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Face Detector'),
      ),
      body: (image == null || faces == null)
          ? const Center(
              child: Text(
                "Processing...",
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height / 1.5,
                          ),
                          child: FittedBox(
                            child: SizedBox(
                              width: image!.width.toDouble(),
                              height: image!.height.toDouble(),
                              child: CustomPaint(
                                painter: FacePainter(image!, faces!),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          "Detected: ${faces!.length} person${faces!.length > 1 ? 's' : ''}",
                        ),
                      ),
                    ),
                    (isSmilling > 0)
                        ? Text("${isSmilling} is smilling")
                        : const SizedBox.shrink(),
                    (faces!.length - isSmilling > 0)
                        ? Text(
                            "${faces!.length - isSmilling} may not be smilling")
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
    );
  }
}
