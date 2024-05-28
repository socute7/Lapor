import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class TambahPage extends StatefulWidget {
  @override
  _TambahPageState createState() => _TambahPageState();
}

class _TambahPageState extends State<TambahPage> {
  File? image;
  TextEditingController judulController = TextEditingController();
  TextEditingController statusController = TextEditingController();

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

  Future<void> tambahLaporan() async {
    if (image == null ||
        judulController.text.isEmpty ||
        statusController.text.isEmpty) {
      print('Please fill all fields');
      return;
    }

    var request = http.MultipartRequest(
        'POST', Uri.parse('http://192.168.0.222/myapp/add.php'));
    request.fields['judul'] = judulController.text;
    request.fields['status'] = statusController.text;
    request.fields['tanggal'] = DateTime.now().toString();
    request.files.add(await http.MultipartFile.fromPath('gambar', image!.path));

    var response = await request.send();

    if (response.statusCode == 201) {
      print('Laporan berhasil ditambahkan');
      setState(() {
        image = null;
        judulController.clear();
        statusController.clear();
      });
    } else {
      print('Failed to add laporan: ${response.reasonPhrase}');
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
