import 'dart:math';

import 'package:face_detection/coordinates_translator.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FacePainter extends CustomPainter {
  ui.Image image;
  List<Face> faces;
  List<Rect> rects = [];
  bool contours;
  FacePainter(this.image, this.faces, {this.contours = false}) {
    for (var face in faces) {
      rects.add(face.boundingBox);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paintBoundingBox = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = contours ? 3.0 : 5.0
      ..color = Colors.green;

    Paint paintPoint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Colors.white;

    Paint paintLine = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = Colors.blue;

    canvas.drawImage(image, Offset.zero, Paint());

    for (int i = 0; i < faces.length; i++) {
      canvas.drawRect(rects[i], paintBoundingBox);
    }
    if (!contours) return;
    for (Face face in faces) {
      void paintContourPoint(FaceContourType type,
          {Color color = Colors.blue, bool circle = false}) {
        final faceContour = face.contours[type];
        if (faceContour?.points == null) return;
        for (int i = 0; i < faceContour!.points.length; i++) {
          Point point1 = faceContour.points[i];
          Point point2 =
              faceContour.points[(i + 1) % faceContour.points.length];

          canvas.drawCircle(
              Offset(
                translateX(
                  point1.x.toDouble(),
                  InputImageRotation.rotation0deg,
                  size,
                  Size(
                    image.width.toDouble(),
                    image.height.toDouble(),
                  ),
                ),
                translateY(
                  point1.y.toDouble(),
                  InputImageRotation.rotation0deg,
                  size,
                  Size(
                    image.width.toDouble(),
                    image.height.toDouble(),
                  ),
                ),
              ),
              1,
              paintPoint);
          if (i + 1 == faceContour.points.length && circle == false) return;
          Paint paintLinenew = paintLine;
          paintLinenew.color = color;
          canvas.drawLine(Offset(point1.x.toDouble(), point1.y.toDouble()),
              Offset(point2.x.toDouble(), point2.y.toDouble()), paintLinenew);
        }
      }

      paintContourPoint(FaceContourType.face, circle: true);
      paintContourPoint(FaceContourType.leftEyebrowTop, color: Colors.pink);
      paintContourPoint(FaceContourType.leftEyebrowBottom, color: Colors.pink);
      paintContourPoint(FaceContourType.rightEyebrowTop, color: Colors.pink);
      paintContourPoint(FaceContourType.rightEyebrowBottom, color: Colors.pink);
      paintContourPoint(FaceContourType.leftEye, color: Colors.red);
      paintContourPoint(FaceContourType.rightEye, color: Colors.red);
      paintContourPoint(FaceContourType.upperLipTop,
          color: Colors.lightBlueAccent);
      paintContourPoint(FaceContourType.upperLipBottom,
          color: Colors.lightBlueAccent);
      paintContourPoint(FaceContourType.lowerLipTop,
          color: Colors.lightBlueAccent);
      paintContourPoint(FaceContourType.lowerLipBottom,
          color: Colors.lightBlueAccent);
      paintContourPoint(FaceContourType.noseBridge, color: Colors.purple);
      paintContourPoint(FaceContourType.noseBottom,
          color: Colors.lightGreenAccent);
      paintContourPoint(FaceContourType.leftCheek);
      paintContourPoint(FaceContourType.rightCheek);
    }
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return image != oldDelegate.image || faces != oldDelegate.faces;
  }
}
