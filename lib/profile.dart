import 'package:flutter/material.dart';
import 'package:myapps/login.dart';
import 'package:provider/provider.dart';
import 'api_service.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context);
    final String username = apiService.currentUser?['username'] ?? 'User';

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/user.png'),
            ),
            SizedBox(height: 20),
            Text(
              username,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'User',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
