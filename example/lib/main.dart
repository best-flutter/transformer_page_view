import 'package:flutter/material.dart';

import 'package:transformer_page_view/transformer_page_view.dart';

// 1111111 !!!!!!

void main() => runApp(new MyApp());
List<Color> list = [Colors.yellow, Colors.green, Colors.blue];

List<String> images = ["assets/Hepburn2.jpg",
"assets/Hepburn3.jpg",
"assets/Hepburn4.jpg",
"assets/Hepburn5.jpg",];

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

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    _controller = new IndexController();
    super.initState();
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
              new SizedBox(width: 8.0,),
              new RaisedButton(
                onPressed: () {
                  _controller.next();
                },
                color: Colors.blue,
                child: new Text("Next"),
              ),
            ],
          ),
        new Expanded(child:  new SizedBox(
          child:  new TransformerPageView(
              loop: true,
              controller: _controller,
              transformer: new AccordionTransformer(),
              itemBuilder: (BuildContext context, int index) {
                return new Image.asset(images[index],fit: BoxFit.fill,);
              },
              itemCount: 3),
        ))
        ],
      ),
    );
  }
}
