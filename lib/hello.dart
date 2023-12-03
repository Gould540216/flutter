import 'package:my_chat_app/requester/requester.dart';
import 'package:flutter/material.dart';

class Hello extends StatefulWidget {
  const Hello({Key? key}) : super(key: key);

  @override
  _HelloState createState() => _HelloState();
}

class _HelloState extends State<Hello> {
  var _message = "";

  @override
  void initState() {
    super.initState();
    Requester().helloRequester().then((value) {
      setState(() {
        _message = value;
      });
    }).onError((error, stackTrace) {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text("認証に失敗しました。再ログインをお願いします。"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context), child: Text("OK")),
              ],
            );
          }).then((_) {
        Navigator.pop(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              Requester().logoutRequester().then((_) {
                Navigator.pop(context);
              });
            },
            child: const Text('LOGOUT',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0)),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 100),
        child: Center(
          child: Column(
            children: [Text(_message, style: TextStyle(fontSize: 50.0))],
          ),
        ),
      ),
    );
  }
}
