import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:form_field_validator/form_field_validator.dart';
import './validators.dart';
import './screens/signup.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<SignUpPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  Future<void> login() async {
    final response = await http.post(
      Uri.parse(
          'https://eggnworks-test-df2c2bd9dc3a.herokuapp.com/api/users/create/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "username": nameController.text,
        "password": passwordController.text,
        "email": emailController.text,
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('登録')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'メールアドレス'),
            ),
            TextFormField(
              controller: nameController,
              validator: nameValidator,
              decoration: InputDecoration(labelText: 'ユーザー名'),
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'パスワード'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: login,
              child: Text('登録'),
            ),
          ],
        ),
      ),
    );
  }
}
