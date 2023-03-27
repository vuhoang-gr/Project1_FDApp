import 'package:face_detection/screen/detect_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  Widget createButton({imgSource, context}) {
    void onPickImageSelected(String source) async {
      var imageSource;
      if (source == 'Camera') {
        imageSource = ImageSource.camera;
      } else {
        imageSource = ImageSource.gallery;
      }
      try {
        final ImagePicker _picker = ImagePicker();
        // Pick an image
        final file = await _picker.pickImage(source: imageSource);
        if (file == null) {
          throw Exception('File is not available');
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetectScreen(
              path: file.path,
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
        ));
      }
    }

    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: GestureDetector(
          onTap: () {
            onPickImageSelected(imgSource);
          },
          child: Container(
            color: Colors.blue,
            padding: EdgeInsets.all(20),
            child: Text(
              imgSource,
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Face Detection'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              'Pick Image',
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              children: [
                createButton(imgSource: 'Camera', context: context),
                createButton(imgSource: 'Gallery', context: context)
              ],
            )
          ],
        ),
      ),
    );
  }
}
