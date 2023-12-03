import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './home_page.dart';
import './home_page_backup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:form_field_validator/form_field_validator.dart';
import './validators.dart';
import './screens/signup.dart';
import './signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    final response = await http.post(
      Uri.parse(
          'https://eggnworks-test-df2c2bd9dc3a.herokuapp.com/authen/jwt/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': nameController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      print("Response data: $responseData");

      if (responseData['access'] != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', responseData['access'] as String);
        await prefs.setString("email", nameController.text);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => InfinityScrollPage()),
        );
        print('Login Success');
      } else {
        print('Login Error: Unexpected response');
      }
    } else {
      print('HTTP Error with code: ${response.statusCode}');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('エラー'),
          content: Text("入力内容が正しくありません"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('閉じる'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ログイン')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              validator: nameValidator,
              decoration: InputDecoration(labelText: 'メールアドレス'),
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'パスワード'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: login,
              child: Text('ログイン'),
            ),
            ElevatedButton(
              onPressed: () => {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return SignUpPage();
                }))
              },
              child: Text('新規登録'),
            ),
          ],
        ),
      ),
    );
  }
}
