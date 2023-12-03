import 'package:flutter/material.dart';
import './login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './screens/signup.dart';
import './detail.dart';
import './screens/menu.dart';
import './post.dart';
import './post_image.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'エッグンワークス',
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  _MyHomePageState({Key? key});
  int page = 1;
  bool loading = false;

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MenuScreen(),
      ),
    );
  }

  Future<void> load(BuildContext context) async {
    SharedPreferences prefs2 = await SharedPreferences.getInstance();
    final ss = prefs2.getString("email");
    print(ss);
  }

  Future<void> signup(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      ),
    );
  }

  List items = [];
  List items2 = [];
  List items3 = [];

  Future<void> getData() async {
    if (loading) {
      return null;
    }
    loading = true;
    try {
      var response = await http.get(Uri.https(
          'eggnworks-test-df2c2bd9dc3a.herokuapp.com',
          '/api_Mj5AB76G/',
          {'q': '{Flutter}', 'maxResults': '40', 'langRestrict': 'ja'}));

      var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        page += 1;
        if (jsonResponse is List) {
          items ??= <String>[];
          jsonResponse.forEach((dynamic elem) {
            if (elem is Map) {
              items.add(elem['title'] as String);
            }
          });
        }
        if (jsonResponse is List) {
          items2 ??= <String>[];
          jsonResponse.forEach((dynamic elem) {
            if (elem is Map) {
              items2.add(elem['thumbnail'] as String);
            }
          });
        }
        if (jsonResponse is List) {
          items3 ??= <String>[];
          jsonResponse.forEach((dynamic elem) {
            if (elem is Map) {
              items3.add(elem['id']);
            }
          });
        }
      });
    } finally {
      loading = false;
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var length = items?.length ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('エッグンワークス'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => load(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          if (index == length) {
            getData();

            return Center(
              child: Container(
                margin: const EdgeInsets.only(top: 8.0),
                width: 32.0,
                height: 32.0,
                child: const CircularProgressIndicator(),
              ),
            );
          } else if (index > length) {
            return null;
          }
          var title = items[index];
          var thumbnail = items2[index];
          var id = items3[index];
          return Card(
            child: Column(
              children: <Widget>[
                ListTile(
                    leading: Image.network(
                      thumbnail,
                    ),
                    key: ValueKey<String>(title),
                    title: Text(title),
                    onTap: () => {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                MyApp2(value: id),
                          ))
                        }),
                const Text('詳しく見る')
              ],
            ),
          );
        },
      ),
      drawer: Drawer(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20.0),
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => Post()));
                  },
                  child: const Text('投稿'),
                )),
            Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const MyApp_image()));
                  },
                  child: const Text('画像投稿'),
                )),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('あ'),
            ),
          ],
        ),
      ),
    );
  }
}
