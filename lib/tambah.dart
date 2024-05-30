import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'api_service.dart';

class TambahPage extends StatefulWidget {
  @override
  _TambahPageState createState() => _TambahPageState();
}

class _TambahPageState extends State<TambahPage> {
  File? image;
  TextEditingController judulController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  final ApiService _apiService = ApiService();

  Future pickImage() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage == null) return;
      final imageTemp = File(pickedImage.path);
      setState(() => image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<void> tambahLaporan() async {
    if (image == null ||
        judulController.text.isEmpty ||
        statusController.text.isEmpty) {
      print('Please fill all fields');
      return;
    }

    try {
      await _apiService.tambahLaporan(
          judulController.text, statusController.text, image!);
      print('Laporan berhasil ditambahkan');
      setState(() {
        image = null;
        judulController.clear();
        statusController.clear();
      });
    } catch (e) {
      print('Failed to add laporan: $e');
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
                child: TextField(
                  controller: judulController,
                  decoration: InputDecoration(
                    hintText: 'Judul Laporan',
                  ),
                ),
              ),
            ),
            Container(
              width: 300,
              height: 50,
              margin: EdgeInsets.only(bottom: 10),
              color: Colors.grey[300],
              child: Center(
                child: TextField(
                  controller: statusController,
                  decoration: InputDecoration(
                    hintText: 'Status',
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: tambahLaporan,
              child: Text('Tambah Laporan'),
            ),
          ],
        ),
      ),
    );
  }
}
