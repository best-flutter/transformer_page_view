import 'package:example/buildin_transformers.dart';
import 'package:example/images.dart';
import 'package:example/screens/ProductListView.dart';
import 'package:example/welcome.dart';
import 'package:example/zero.dart';
import 'package:flutter/material.dart';

import 'package:transformer_page_view/transformer_page_view.dart';

import 'package:flutter/cupertino.dart';
import 'dart:math' as Math;
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
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late IndexController _controller;
  List<String> _types = [
    "AccordionTransformer",
    "ThreeDTransformer",
    "ScaleAndFadeTransformer",
    "ZoomInPageTransformer",
    "ZoomOutPageTransformer",
    "DeepthPageTransformer"
  ];

  late String _type;
  late FixedExtentScrollController controller;
  int _index = 0;
  double _viewportFraction = 1.0;

  @override
  void initState() {
    _controller = new IndexController();
    _type = "AccordionTransformer";
    controller = new FixedExtentScrollController();
    super.initState();
  }

  PageTransformer getTransformer() {
    switch (_type) {
      case 'AccordionTransformer':
        return new AccordionTransformer();
      case 'ThreeDTransformer':
        return new ThreeDTransformer();
      case 'ScaleAndFadeTransformer':
        return new ScaleAndFadeTransformer();
      case 'ZoomInPageTransformer':
        return new ZoomInPageTransformer();
      case 'ZoomOutPageTransformer':
        return new ZoomOutPageTransformer();
      case 'DeepthPageTransformer':
        return new DeepthPageTransformer();
    }

    throw new Exception("Not a type");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        actions: <Widget>[
          new InkWell(
            child: new Text("route"),
            onTap: () {
              Navigator.push(context, new MaterialPageRoute(builder: (c) {
                return new ProductListView();
              }));
            },
          )
        ],
      ),
      body: new Column(
        children: <Widget>[
          new Wrap(
            children: <Widget>[
              new ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                onPressed: () {
                  _controller.move(new Math.Random().nextInt(5));
                },
                //color: Colors.blue,
                child: new Text("Random"),
              ),
              new ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                onPressed: () {
                  Navigator.of(context)
                      .push(new MaterialPageRoute(builder: (b) {
                    return new Scaffold(
                      appBar: new AppBar(
                        title: new Text("images"),
                      ),
                      body: new ImageTest(),
                    );
                  }));
                },
                //color: Colors.blue,
                child: new Text("Image"),
              ),
              new ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                onPressed: () {
                  Navigator.of(context)
                      .push(new MaterialPageRoute(builder: (b) {
                    return new Scaffold(
                        appBar: new AppBar(
                          title: new Text("welcome"),
                        ),
                        body: new Welcome(0));
                  }));
                },
                //color: Colors.blue,
                child: new Text("Welcome"),
              ),
              new ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                onPressed: () {
                  Navigator.of(context)
                      .push(new MaterialPageRoute(builder: (b) {
                    return new Zero();
                  }));
                },
                //color: Colors.blue,
                child: new Text("Zero"),
              ),
            ],
          ),
          new Row(
            children: <Widget>[
              new ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                onPressed: () {
                  _controller.previous();
                },
                //color: Colors.blue,
                child: new Text("Preious"),
              ),
              new SizedBox(
                width: 8.0,
              ),
              new ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                onPressed: () {
                  _controller.next();
                },
                //color: Colors.blue,
                child: new Text("Next"),
              ),
              new SizedBox(
                width: 8.0,
              ),
              new ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (_) {
                        return new CupertinoPicker(
                            scrollController: controller,
                            itemExtent: 30.0,
                            onSelectedItemChanged: (int index) {
                              setState(() {
                                controller = new FixedExtentScrollController(
                                    initialItem: index);
                                _type = _types[index];
                                if (_type == 'ScaleAndFadeTransformer') {
                                  _viewportFraction = 0.8;
                                } else {
                                  _viewportFraction = 1.0;
                                }
                              });
                            },
                            children: _types.map((t) => new Text(t)).toList());
                      });
                },
                //color: Colors.blue,
                child: new Text("Animation"),
              ),
            ],
          ),
          new Expanded(
              child: new SizedBox(
            child: new TransformerPageView(
                loop: false,
                index: _index,
                viewportFraction: _viewportFraction,
                controller: _controller,
                transformer: getTransformer(),
                onPageChanged: (int index) {
                  setState(() {
                    _index = index;
                  });
                },
                itemBuilder: (BuildContext context, int index) {
                  return new Image.asset(
                    images[index],
                    fit: BoxFit.fill,
                  );
                },
                itemCount: 3),
          ))
        ],
      ),
    );
  }
}
