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

class Welcome extends StatelessWidget {
  final List<String> images = [
    "assets/home.png",
    "assets/good.png",
    "assets/image.png",
    "assets/edit.png"
  ];

  final List<String> titles = [
    "Welcome",
    "Simple to use",
    "Easy parallax",
    "Customizable"
  ];
  final List<String> subtitles = [
    "Flutter TransformerPageView, for welcome screen, banner, image catalog and more",
    "Simple api,easy to understand,powerful adn strong",
    "Create parallax by a few lines of code",
    "Highly customizable, the only boundary is our mind. :)"
  ];

  final List<Color> backgroundColors = [
    new Color(0xffF67904),
    new Color(0xffD12D2E),
    new Color(0xff7A1EA1),
    new Color(0xff1773CF)
  ];

  @override
  Widget build(BuildContext context) {
    return new TransformerPageView(
        loop: false,
        transformer: new PageTransformerBuilder(
            builder: (Widget child, TransformInfo info) {
          return new ParallaxColor(
            colors: backgroundColors,
            info: info,
            child: new Column(
              children: <Widget>[
                new Expanded(
                    child: new ParallaxContainer(
                  child: new Image.asset(images[info.index]),
                  position: info.position,
                  opacityFactor: 1.0,
                  translationFactor: 400.0,
                )),
                new Text(
                  titles[info.index],
                  style: new TextStyle(fontSize: 30.0, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                new Padding(
                    padding: new EdgeInsets.fromLTRB(40.0, 30.0, 40.0, 50.0),
                    child: new Text(subtitles[info.index],
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            fontSize: 13.0, color: Colors.white))),
              ],
            ),
          );
        }),
        itemCount: 4);
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Welcome(),
    );
  }
}
