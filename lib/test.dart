import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(title: '非同期処理でも'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<String> getResult() async {
    await Future.delayed(Duration(seconds: 3));
    return "合格";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: FutureBuilder<String?>(
        future: getResult(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            final error = snapshot.error;
            return Text(
              '$error',
              style: TextStyle(
                fontSize: 60,
              ),
            );
          } else if (snapshot.hasData) {
            String result = snapshot.data!;
            return Text(
              '$result',
              style: TextStyle(
                fontSize: 60,
              ),
            );
          } else {
            return const Text(
              "しばらくお待ちください",
              style: TextStyle(
                fontSize: 30,
              ),
            );
          }
        },
      )),
    );
  }
}
