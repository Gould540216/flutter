import 'package:flutter/material.dart';
import './home_page.dart';
import './home_page_backup.dart';
import './login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;
  MyApp({Key? key, this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: token == null ? const MenuScreen() : InfinityScrollPage(),
    );
  }
}
