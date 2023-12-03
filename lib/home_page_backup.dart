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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InfinityScrollPage(),
    );
  }
}

class InfinityScrollPage extends StatefulWidget {
  const InfinityScrollPage({Key? key}) : super(key: key);

  @override
  State<InfinityScrollPage> createState() => _InfinityScrollPageState();
}

class _InfinityScrollPageState extends State<InfinityScrollPage> {
  final List<String> _contents = [];
  final List<String> _contents2 = [];
  final List<String> _contents3 = [];
  final int loadLength = 30;

  int _lastIndex = 0;

  Future<void> _getContents() async {
    await Future.delayed(const Duration(seconds: 1));
    var response = await http.get(Uri.https(
        'eggnworks-test-df2c2bd9dc3a.herokuapp.com',
        '/api_Mj5AB76G/',
        {'q': '{Flutter}', 'maxResults': '40', 'langRestrict': 'ja'}));

    var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

    for (int i = _lastIndex; i < _lastIndex + loadLength; i++) {
      _contents.add(jsonResponse[i]["thumbnail"]);
      _contents2.add(jsonResponse[i]["id"].toString());
      _contents3.add(jsonResponse[i]["title"]);
    }

    _lastIndex += loadLength;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'images/museum_logo.png',
          height: 60,
          width: 135,
        ),
        backgroundColor: Color.fromRGBO(176, 142, 130, 1),
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
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const MyApp_image()));
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
        child: FutureBuilder(
          future: _getContents(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            //4
            return InfinityListView(
              contents: _contents,
              contents2: _contents2,
              contents3: _contents3,
              getContents: _getContents,
            );
          },
        ),
      ),
    );
  }
}

class InfinityListView extends StatefulWidget {
  final List<String> contents;
  final List<String> contents2;
  final List<String> contents3;
  final Future<void> Function() getContents;

  const InfinityListView({
    Key? key,
    required this.contents,
    required this.contents2,
    required this.contents3,
    required this.getContents,
  }) : super(key: key);

  @override
  State<InfinityListView> createState() => _InfinityListViewState();
}

class _InfinityListViewState extends State<InfinityListView> {
  //5
  late ScrollController _scrollController;
  //6
  bool _isLoading = false;

  //7
  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent * 0.95 &&
          !_isLoading) {
        _isLoading = true;

        await widget.getContents();

        setState(() {
          _isLoading = false;
        });
      }
    });
    super.initState();
  }

  //8
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 50.0),

      //9
      controller: _scrollController,
      //10
      itemCount: widget.contents2.length + 1,

      itemBuilder: (BuildContext context, int index) {
        //11
        if (widget.contents2.length == index) {
          return const SizedBox(
            height: 50,
            width: 50,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        var id = widget.contents2[index];
        const Padding(padding: EdgeInsets.all(100.0));
        return Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 0,
          children: [
            Image.network(
              widget.contents[index],
              width: 150,
              height: 150,
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 150.0),
            ),
            ElevatedButton(
                child: Text(widget.contents3[index]),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return MyApp2(value: int.parse(id));
                      },
                    ),
                  );
                })
          ],
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
    );
  }
}
