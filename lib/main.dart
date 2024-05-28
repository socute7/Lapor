import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'dashboard.dart';
import 'setting.dart';
import 'profile.dart';
import 'tambah.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter PostgreSQL Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/dashboard': (context) => DashboardPage(),
        '/setting': (context) => SettingPage(),
        '/profile': (context) => ProfilePage(),
        '/tambah': (context) => TambahPage(),
      },
    );
  }
}
