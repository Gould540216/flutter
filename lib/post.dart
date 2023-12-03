import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main() => runApp(Post());

class NetworkHelper {
  NetworkHelper({required this.url});

  final String url;

  Future<dynamic> getData() async {
    http.Response response;

    response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String data = response.body;
      dynamic jsonObjects = jsonDecode(data);
      return jsonObjects;
    } else {
      print(response.statusCode);
    }
  }
}

class Post extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EggnWorks',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xff2196f3),
        canvasColor: const Color(0xfffafafa),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<String>>? urls;
  Future<List<String>> getJsons() async {
    List<String> jsonUrls = [];

    String url =
        "https://eggnworks-test-df2c2bd9dc3a.herokuapp.com/api_Mj5AB76G/";
    NetworkHelper networkHelper = NetworkHelper(url: url);

    List<dynamic> data = await networkHelper.getData();
    print(data[1]["thumbnail"]);
    for (var i = 0; i < data.length; i++) {
      jsonUrls.add(data[i]["thumbnail"]);
    }

    return jsonUrls;
  }

  Future<List<String>>? urls2;
  Future<List<String>> getJsons2() async {
    List<String> jsonUrls2 = [];

    String url =
        "https://eggnworks-test-df2c2bd9dc3a.herokuapp.com/api_Mj5AB76G/";
    NetworkHelper networkHelper = NetworkHelper(url: url);

    List<dynamic> data = await networkHelper.getData();
    print(data[1]["title"]);
    for (var i = 0; i < data.length; i++) {
      jsonUrls2.add(data[i]["title"]);
    }

    return jsonUrls2;
  }

  @override
  void initState() {
    urls = getJsons();
    urls2 = getJsons2();
    super.initState();
  }

  final _controller = TextEditingController();
  static const host = 'www.eggnworks.jp';
  static const path = '/api/';
  static const url =
      "https://eggnworks-test-df2c2bd9dc3a.herokuapp.com/api_Mj5AB76G/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Text(
              'INTERNET ACCESS.',
              style: TextStyle(fontSize: 32, fontWeight: ui.FontWeight.w500),
            ),
            Padding(padding: EdgeInsets.all(10.0)),
            TextField(
              controller: _controller,
              style: TextStyle(
                fontSize: 24,
              ),
              minLines: 1,
              maxLines: 5,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.open_in_new),
        onPressed: () {
          _request();
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: Text("loaded!"),
                    content: Text("get content from URI."),
                  ));
        },
      ),
    );
  }

  void _upload() async {
    final pickerFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickerFile == null) {
      return;
    }
    File file = File(pickerFile.path);
    Uri url = Uri.parse(
        "https://eggnworks-test-df2c2bd9dc3a.herokuapp.com/api_Mj5AB76G/");
    Map<String, String> headers = {'content-type': 'multipart/form-data'};
    String body = json.encode({'title': 'aaa', 'thumbnail': 'bbb'});

    http.Response resp = await http.post(url, headers: headers, body: body);

    if (resp.statusCode != 200) {
      setState(() {
        int statusCode = resp.statusCode;
        var _content = "Failed to post $statusCode";
      });
      return;
    }
    setState(() {
      var _content = resp.body;
    });
  }

  Future<void> main(List<String> args) async {
    final response = await multipart(
      method: 'POST',
      url: Uri.https('https://eggnworks-test-df2c2bd9dc3a.herokuapp.com',
          '/api_Mj5AB76G/'),
      files: [
        http.MultipartFile.fromBytes(
          'thumbnail',
          File('./media/icon.png').readAsBytesSync(),
        ),
      ],
    );

    print(response.statusCode);
    print(response.body);
  }

  Future<http.Response> multipart({
    required String method,
    required Uri url,
    required List<http.MultipartFile> files,
  }) async {
    final request = http.MultipartRequest(method, url);
    request.files.addAll(files);
    request.headers.addAll({'content-type': 'multipart/form-data'});
    final stream = await request.send();
    return http.Response.fromStream(stream).then((response) {
      if (response.statusCode == 200) {
        return response;
      }
      return Future.error(response);
    });
  }

  void _request() async {
    Uri url = Uri.parse(
        "https://eggnworks-test-df2c2bd9dc3a.herokuapp.com/api_Mj5AB76G/");
    Map<String, String> headers = {'content-type': 'application/json'};
    String body =
        json.encode({'title': _controller.text, 'content': 'I am Joker!'});

    http.Response resp = await http.post(url, headers: headers, body: body);

    if (resp.statusCode != 200) {
      setState(() {
        int statusCode = resp.statusCode;
        var _content = "Failed to post $statusCode";
      });
      return;
    }
    setState(() {
      var _content = resp.body;
    });
  }
}
