import 'package:flutter/material.dart';

import 'package:transformer_page_view/transformer_page_view.dart';

import 'package:flutter/cupertino.dart';

// 1111111 !!!!!!

void main() => runApp(new MyApp());
List<Color> list = [Colors.yellow, Colors.green, Colors.blue];

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

List<String> images = ["assets/1.jpg", "assets/2.jpg", "assets/3.jpg"];

List<String> text0 = ["春归何处。寂寞无行路", "春无踪迹谁知。除非问取黄鹂", "山色江声相与清，卷帘待得月华生"];
List<String> text1 = ["若有人知春去处。唤取归来同住", "百啭无人能解，因风飞过蔷薇", "可怜一曲并船笛，说尽故人离别情。"];

class ImageTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new TransformerPageView(
        loop: true,
        viewportFraction: 0.8,
        transformer: new PageTransformerBuilder(
            builder: (Widget child, TransformInfo info) {
          return new Padding(
            padding: new EdgeInsets.all(10.0),
            child: new Material(
              elevation: 4.0,
              textStyle: new TextStyle(color: Colors.white),
              borderRadius: new BorderRadius.circular(10.0),
              child: new Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  new ParallaxImage.asset(
                    images[info.index],
                    position: info.position,
                  ),
                  new DecoratedBox(
                    decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                        begin: FractionalOffset.bottomCenter,
                        end: FractionalOffset.topCenter,
                        colors: [
                          const Color(0xFF000000),
                          const Color(0x33FFC0CB),
                        ],
                      ),
                    ),
                  ),
                  new Positioned(
                    child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new ParallaxContainer(
                          child: new Text(
                            text0[info.index],
                            style: new TextStyle(fontSize: 15.0),
                          ),
                          position: info.position,
                          translationFactor: 300.0,
                        ),
                        new SizedBox(
                          height: 8.0,
                        ),
                        new ParallaxContainer(
                          child: new Text(text1[info.index],
                              style: new TextStyle(fontSize: 18.0)),
                          position: info.position,
                          translationFactor: 200.0,
                        ),
                      ],
                    ),
                    left: 10.0,
                    right: 10.0,
                    bottom: 10.0,
                  )
                ],
              ),
            ),
          );
        }),
        itemCount: 3);
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Padding(
          padding: new EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 30.0),
          child: new ImageTest()),
    );
  }
}
