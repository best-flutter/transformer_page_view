import 'package:example/buildin_transformers.dart';
import 'package:flutter/material.dart';

import 'package:transformer_page_view/transformer_page_view.dart';

import 'package:flutter/cupertino.dart';

// 1111111 !!!!!!

void main() => runApp(new MyApp());
List<Color> list = [Colors.yellow, Colors.green, Colors.blue];

List<String> images = [
  "assets/Hepburn2.jpg",
  "assets/Hepburn5.jpg",
  "assets/Hepburn4.jpg",
];

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Color> list = [
      Colors.redAccent,
      Colors.blueAccent,
      Colors.greenAccent
    ];
    return new TransformerPageView(
        loop: true,
        transformer: new ZoomOutPageTransformer(),
        itemBuilder: (BuildContext context, int index) {
          return new Container(
            color: list[index % list.length],
            child: new Center(
              child: new Text(
                "$index",
                style: new TextStyle(fontSize: 80.0, color: Colors.white),
              ),
            ),
          );
        },
        itemCount: 3);
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new TestWidget(),
    );
  }
}
