import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FacePainter extends CustomPainter {
  ui.Image image;
  List<Face> faces;
  List<Rect> rects = [];
  FacePainter(this.image, this.faces) {
    for (var face in faces) {
      rects.add(face.boundingBox);
    }
  }
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..color = Colors.green;
    canvas.drawImage(image, Offset.zero, Paint());
    for (int i = 0; i < faces.length; i++) {
      canvas.drawRect(rects[i], paint);
    }
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return image != oldDelegate.image || faces != oldDelegate.faces;
  }
}
