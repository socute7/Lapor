import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'api_service.dart';
import 'login.dart';
import 'register.dart';
import 'dashboard.dart';
import 'setting.dart';
import 'profile.dart';
import 'reset_password.dart';
import 'admin/admin_dashboard.dart';
import 'admin/admin_settings.dart';
import 'tambah.dart'; // Import file TambahPage.dart

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ApiService(),
      child: MyApp(),
    ),
  );
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
        '/tambah': (context) => TambahPage(title: 'Tambah Laporan'),
        '/reset_password': (context) => ResetPasswordPage(),
        '/admin_dashboard': (context) => AdminDashboard(),
        '/admin_settings': (context) => AdminSettings(),
      },
    );
  }
}
