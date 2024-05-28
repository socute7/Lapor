import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class TambahPage extends StatefulWidget {
  @override
  _TambahPageState createState() => _TambahPageState();
}

class _TambahPageState extends State<TambahPage> {
  File? image;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: pickImage,
              child: Container(
                width: 300,
                height: 200,
                color: Colors.grey[300],
                child: image == null
                    ? Icon(
                        Icons.camera_alt,
                        size: 50,
                        color: Colors.grey[700],
                      )
                    : Image.file(
                        image!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 300,
              height: 50,
              margin: EdgeInsets.only(bottom: 10),
              color: Colors.grey[300],
              child: Center(
                child: Text(
                  'Judul Laporan',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: 140,
                  height: 50,
                  margin: EdgeInsets.only(left: 29, bottom: 20),
                  color: Colors.grey[300],
                  child: Center(
                    child: Text(
                      'Action',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  width: 140,
                  height: 50,
                  margin: EdgeInsets.only(right: 29, bottom: 20),
                  color: Colors.grey[300],
                  child: Center(
                    child: Text(
                      '28 May 2024',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
