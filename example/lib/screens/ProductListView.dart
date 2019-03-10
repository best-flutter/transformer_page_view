import 'package:example/screens/ProductDetailView.dart';
import 'package:flutter/material.dart';

import 'package:transformer_page_view/transformer_page_view.dart';

class ProductListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ProductListViewState();
  }
}

class ProductListViewState extends State<ProductListView> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("ProductList"),
      ),
      body: new ListView(
        children: <Widget>[
//          new SizedBox(
//            height: 1000.0,
//            child: new Container(
//              color: Colors.greenAccent,
//            ),
//          ),
          new SizedBox(
            child: new TransformerPageView(
              viewportFraction: 0.8,
              itemCount: 10,
              transformer: new PageTransformerBuilder(builder: (w, i) {
                return w;
              }),
              itemBuilder: (c, i) {
                return new InkWell(
                  onTap: () {
                    Navigator.push(context, new MaterialPageRoute(builder: (c) {
                      return new ProductDetailView();
                    }));
                  },
                  child: new Container(
                    child: new Text("$i"),
                    color: Colors.black26,
                  ),
                );
              },
            ),
            height: 100.0,
          )
        ],
      ),
    );
  }
}
