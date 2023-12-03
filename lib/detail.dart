import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import './home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './post.dart';
import './post_image.dart';
import 'screens/menu.dart';

class Album {
  final int id;
  final String title;
  final String content;
  final String thumbnail;

  const Album({
    required this.id,
    required this.title,
    required this.content,
    required this.thumbnail,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      thumbnail: json['thumbnail'] as String,
    );
  }
}

class MyApp2 extends StatefulWidget {
  final int value;
  const MyApp2({Key? key, required this.value}) : super(key: key);

  @override
  State<MyApp2> createState() => _MyAppState(value);
}

class _MyAppState extends State<MyApp2> {
  _MyAppState(this.value);
  int value;
  late Future<Album> futureAlbum;

  Future<Album> fetchAlbum() async {
    final response = await http.get(Uri.parse(
        'https://eggnworks-test-df2c2bd9dc3a.herokuapp.com/article/${value}/'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Album.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MenuScreen(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'エッグンワークス作品詳細',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('作品詳細'),
          automaticallyImplyLeading: false,
          leading: TextButton(
            child: Text(
              '一覧へ',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        endDrawer: Drawer(
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
                    child: const Text('作品投稿'),
                  )),
              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const MyApp_image()));
                    },
                    child: const Text('画像投稿'),
                  )),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: const Text('マイページ'),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: const Text('開催中の公募'),
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => logout(context),
              ),
            ],
          ),
        ),
        body: Center(
          child: FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Text(snapshot.data!.title.toString()),
                    Text(snapshot.data!.content.toString()),
                    Image.network(snapshot.data!.thumbnail),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
