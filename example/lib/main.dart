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

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  IndexController _controller;
  List<String> _types = [
    "AccordionTransformer",
    "ThreeDTransformer",
    "ScaleAndFadeTransformer",
    "ZoomInPageTransformer",
    "ZoomOutPageTransformer",
    "DeepthPageTransformer"
  ];

  String _type;
  FixedExtentScrollController controller;

  double _viewportFraction = 1.0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
      ),
      body: new Column(
        children: <Widget>[
          new Row(
            children: <Widget>[
              new RaisedButton(
                onPressed: () {
                  _controller.previous();
                },
                color: Colors.blue,
                child: new Text("Preious"),
              ),
              new SizedBox(
                width: 8.0,
              ),
              new RaisedButton(
                onPressed: () {
                  _controller.next();
                },
                color: Colors.blue,
                child: new Text("Next"),
              ),
              new SizedBox(
                width: 8.0,
              ),
              new RaisedButton(
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
                color: Colors.blue,
                child: new Text("Change Animation"),
              ),
            ],
          ),
          new Expanded(
              child: new SizedBox(
            child: new TransformerPageView(
                loop: true,
                viewportFraction: _viewportFraction,
                controller: _controller,
                transformer: getTransformer(),
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
