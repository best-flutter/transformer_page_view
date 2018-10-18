import 'package:flutter/material.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

class Zero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Zero"),
        ),
        body: new TransformerPageView(
          itemCount: 0,
          itemBuilder: (c, i) {
            return new Text("$i");
          },
        ));
  }
}
