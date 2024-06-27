import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tambah Laporan',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TambahPage(title: 'Tambah Laporan'),
    );
  }
}

class TambahPage extends StatefulWidget {
  const TambahPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _TambahPageState createState() => _TambahPageState();
}

class _TambahPageState extends State<TambahPage> {
  File? image;
  TextEditingController judulController = TextEditingController();
  TextEditingController lokasiController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  final ApiService _apiService = ApiService();

  Position? _currentPosition;
  String? _currentAddress;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print(
            'Location permissions are permanently denied, we cannot request permissions.');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _currentPosition = position;
      });

      // Fetch address using obtained lat lng
      await _getAddressFromLatLng(position.latitude, position.longitude);
    } catch (e) {
      print('Failed to get location: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to get current location.'),
      ));
    }
  }

  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark placemark = placemarks.first;
      setState(() {
        _currentAddress =
            '${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.postalCode}';
        lokasiController.text = _currentAddress!;
      });
    } catch (e) {
      print('Failed to get address: $e');
    }
  }

  Future<void> pickImage() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage == null) return;

      // Load the image file
      final imageTemp = File(pickedImage.path);

      // Check if the image is PNG and convert it to JPEG if needed
      if (pickedImage.path.endsWith('.png')) {
        final imageBytes = await imageTemp.readAsBytes();
        final decodedImage = img.decodeImage(imageBytes);
        if (decodedImage != null) {
          final jpgImageBytes = img.encodeJpg(decodedImage);
          final jpgImageFile =
              await File('${pickedImage.path}.jpg').writeAsBytes(jpgImageBytes);
          setState(() => image = jpgImageFile);
        } else {
          setState(() => image = imageTemp);
        }
      } else {
        setState(() => image = imageTemp);
      }
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<void> tambahLaporan() async {
    if (image == null ||
        judulController.text.isEmpty ||
        lokasiController.text.isEmpty ||
        detailController.text.isEmpty) {
      print('Please fill all fields');
      return;
    }

    try {
      String status = "pending";
      await _apiService.tambahLaporan(
        judulController.text,
        lokasiController.text,
        detailController.text,
        status,
        image!,
      );

      print('Laporan berhasil ditambahkan');
      // Navigate to the dashboard page
      Navigator.pushReplacementNamed(context, '/dashboard');
    } catch (e) {
      print('Failed to add laporan: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to add laporan. Please try again later.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 20),
              TextField(
                controller: judulController,
                decoration: InputDecoration(
                  labelText: 'Judul Laporan',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: lokasiController,
                decoration: InputDecoration(
                  labelText: 'Lokasi Laporan',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                  suffixIcon: IconButton(
                    icon: Icon(Icons.my_location),
                    onPressed: _getCurrentLocation,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                maxLines: 5,
                controller: detailController,
                decoration: InputDecoration(
                  labelText: 'Detail Laporan',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: image == null
                      ? Center(
                          child: Icon(
                            Icons.camera_alt,
                            size: 50,
                            color: Colors.grey[700],
                          ),
                        )
                      : Image.file(
                          image!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  'Foto Laporan',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: tambahLaporan,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Color.fromARGB(255, 60, 141, 182),
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  'Tambahkan Laporan',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
