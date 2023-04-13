import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectorDetail extends StatefulWidget {
  const FaceDetectorDetail({super.key, required this.faces});
  final List<Face> faces;

  @override
  State<FaceDetectorDetail> createState() => _FaceDetectorDetailState();
}

class _FaceDetectorDetailState extends State<FaceDetectorDetail> {
  int currentIndex = 0;

  String pointToStr(var x) {
    if (x.x == null) return 'N/a';
    return '(${x.x}, ${x.y})';
  }

  @override
  Widget build(BuildContext context) {
    Face currentFace = widget.faces[currentIndex];
    Color color1 = Color.fromARGB(255, 232, 232, 232);
    List<Widget> landmarks = [];
    for (var item in FaceLandmarkType.values) {
      landmarks.add(RowInfo(
          left: item.name,
          right: pointToStr(currentFace.landmarks[item]?.position)));
    }
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              color: Color.fromARGB(255, 222, 221, 221),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Face ${currentIndex + 1} of ${widget.faces.length}'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (currentIndex == 0) return;
                            setState(() {
                              --currentIndex;
                            });
                          },
                          icon: Icon(Icons.arrow_left),
                        ),
                        IconButton(
                          onPressed: () {
                            if (currentIndex == widget.faces.length - 1) return;
                            setState(() {
                              ++currentIndex;
                            });
                          },
                          icon: Icon(
                            Icons.arrow_right,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    text: 'Bounding polygon',
                    color: Color.fromARGB(255, 232, 232, 232),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: TextField(
                    text:
                        '${currentFace.boundingBox.left}, ${currentFace.boundingBox.top}, ${currentFace.boundingBox.right}, ${currentFace.boundingBox.bottom}',
                  ),
                ),
              ],
            ),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      text: 'Angles of rotation',
                      color: color1,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: TextField(
                      text:
                          'X:${currentFace.headEulerAngleX}, Y:${currentFace.headEulerAngleY}, Z:${currentFace.headEulerAngleZ}',
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    text: 'Tracking ID',
                    color: color1,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: TextField(
                    text: '${currentFace.trackingId}',
                  ),
                ),
              ],
            ),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      text: 'Facial landmarks',
                      color: color1,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: landmarks,
                    ),
                  ),
                ],
              ),
            ),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      text: 'Feature probabilities',
                      color: color1,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RowInfo(
                          left: 'Smiling',
                          right: currentFace.smilingProbability != null
                              ? currentFace.smilingProbability!
                                  .toStringAsFixed(3)
                              : 'N/a',
                        ),
                        RowInfo(
                          left: 'Left eye open',
                          right: currentFace.leftEyeOpenProbability != null
                              ? currentFace.leftEyeOpenProbability!
                                  .toStringAsFixed(3)
                              : 'N/a',
                        ),
                        RowInfo(
                          left: 'Right eye open',
                          right: currentFace.rightEyeOpenProbability != null
                              ? currentFace.rightEyeOpenProbability!
                                  .toStringAsFixed(3)
                              : 'N/a',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RowInfo extends StatelessWidget {
  const RowInfo({
    super.key,
    required this.left,
    required this.right,
  });

  final String left;
  final String right;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              left,
            ),
            Text(right),
          ],
        ),
      ),
    );
  }
}

class TextField extends StatelessWidget {
  const TextField({super.key, required this.text, this.color});
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.5),
        color: color,
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Text(text),
      ),
    );
  }
}
