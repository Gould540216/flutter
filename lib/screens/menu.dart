import 'package:flutter/material.dart';
import './signup.dart';
import '../login_page.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('エッグンワークス'),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
              const Text(
                '推し作家をみつけよう。',
              ),
              const SizedBox(
                height: 16,
              ),
              TextButton(
                  child: const Text('ログイン'),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage(),
                    ));
                  }),
              TextButton(
                  child: const Text('新規会員登録'),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => SignupScreen(),
                    ));
                  }),
            ])));
  }
}
