// import 'package:flutter/material.dart';

// import 'package:transformer_page_view/transformer_page_view.dart';

// import 'package:flutter/cupertino.dart';

// void main() => runApp(new MyApp());

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       title: 'Flutter Demo',
//       theme: new ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
//         // counter didn't reset back to zero; the application is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: new MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({
//     Key? key,
//     required this.title,
//   }) : super(key: key);

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   _MyHomePageState createState() => new _MyHomePageState();
// }

// class RadioGroup extends StatefulWidget {
//   final List<String> titles;

//   final ValueChanged<int> onIndexChanged;

//   const RadioGroup({
//     Key? key,
//     required this.titles,
//     required this.onIndexChanged,
//   }) : super(key: key);

//   @override
//   State<StatefulWidget> createState() {
//     return new _RadioGroupState();
//   }
// }

// class _RadioGroupState extends State<RadioGroup> {
//   int _index = 1;

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> list = [];
//     for (int i = 0; i < widget.titles.length; ++i) {
//       list.add(((String title, int index) {
//         return new Row(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             new Radio<int>(
//                 value: index,
//                 groupValue: _index,
//                 onChanged: (int? index) {
//                   setState(() {
//                     _index = index!;
//                     widget.onIndexChanged(_index);
//                   });
//                 }),
//             new Text(title)
//           ],
//         );
//       })(widget.titles[i], i));
//     }

//     return new Wrap(
//       children: list,
//     );
//   }
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _index = 1;

//   double size = 20.0;
//   double activeSize = 30.0;

//   late PageController controller;

//   PageIndicatorLayout layout = PageIndicatorLayout.SLIDE;

//   List<PageIndicatorLayout> layouts = PageIndicatorLayout.values;

//   bool loop = false;

//   @override
//   void initState() {
//     controller = new PageController();
//     super.initState();
//   }

//   @override
//   void didUpdateWidget(MyHomePage oldWidget) {
//     super.didUpdateWidget(oldWidget);
//   }

//   @override
//   Widget build(BuildContext context) {
//     var children = <Widget>[
//       new Container(
//         color: Colors.red,
//       ),
//       new Container(
//         color: Colors.green,
//       ),
//       new Container(
//         color: Colors.blueAccent,
//       ),
//       new Container(
//         color: Colors.grey,
//       )
//     ];
//     return new Scaffold(
//         appBar: new AppBar(
//           title: new Text(widget.title),
//         ),
//         body: new Column(
//           children: <Widget>[
//             new Row(
//               children: <Widget>[
//                 new Checkbox(
//                     value: loop,
//                     onChanged: (bool? value) {
//                       setState(() {
//                         if (value!) {
//                           controller = new TransformerPageController(
//                               itemCount: 4, loop: true);
//                         } else {
//                           controller = new PageController(
//                             initialPage: 0,
//                           );
//                         }
//                         loop = value;
//                       });
//                     }),
//                 new Text("loop"),
//               ],
//             ),
//             new RadioGroup(
//               titles: layouts.map((s) {
//                 var str = s.toString();
//                 return str.substring(str.indexOf(".") + 1);
//               }).toList(),
//               onIndexChanged: (int index) {
//                 setState(() {
//                   _index = index;
//                   layout = layouts[index];
//                 });
//               },
//             ),
//             new Expanded(
//                 child: new Stack(
//               children: <Widget>[
//                 loop
//                     ? new TransformerPageView.children(
//                         children: children,
//                         pageController:
//                             controller as TransformerPageController?,
//                       )
//                     : new PageView(
//                         controller: controller,
//                         children: children,
//                       ),
//                 new Align(
//                   alignment: Alignment.bottomCenter,
//                   child: new Padding(
//                     padding: new EdgeInsets.only(bottom: 20.0),
//                     child: new PageIndicator(
//                       layout: layout,
//                       size: size,
//                       activeSize: activeSize,
//                       controller: controller,
//                       space: 5.0,
//                       count: 4,
//                     ),
//                   ),
//                 )
//               ],
//             ))
//           ],
//         ));
//   }
// }

//-----------------------------------------------------------------------------------

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
