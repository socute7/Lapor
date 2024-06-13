import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class ApiService {
  static const String _baseUrl = 'http://192.168.1.144/myapp';

  Future<Map<String, dynamic>> register(
      String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>> resetPassword(
      String email, String newPassword) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/reset_password.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to reset password');
    }
  }

  Future<void> tambahLaporan(String judul, String status, File image) async {
    var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/add.php'));
    request.fields['judul'] = judul;
    request.fields['status'] = status;
    request.fields['tanggal'] = DateTime.now().toString();
    request.files.add(await http.MultipartFile.fromPath('gambar', image.path));

    var response = await request.send();

    if (response.statusCode != 201) {
      throw Exception('Failed to add laporan: ${response.reasonPhrase}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.get(Uri.parse('$_baseUrl/data.php'));

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);
      List<Map<String, dynamic>> data = [];

      for (var item in responseData) {
        String imagePath = '$_baseUrl/upload/${item['gambar']}';
        Map<String, dynamic> dataItem = {
          'judul': item['judul'],
          'status': item['status'],
          'tanggal': item['tanggal'],
          'imagePath': imagePath,
        };
        data.add(dataItem);
      }

      return data;
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}
