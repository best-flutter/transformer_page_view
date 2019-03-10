import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:transformer_page_view/transformer_page_view.dart';

void main() {
  testWidgets('TransformerPageView basic usage', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
        home: new TransformerPageView(
            itemBuilder: (context, index) {
              return Text("0");
            },
            itemCount: 10)));

    expect(find.text("0", skipOffstage: false), findsOneWidget);
  });
  testWidgets('Zero item count ', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
        home: new TransformerPageView(
            transformer: new PageTransformerBuilder(
                builder: (Widget child, TransformInfo info) {
              return new Container(
                child: new Text("0"),
              );
            }),
            itemCount: 0)));

    expect(find.text("0", skipOffstage: false), findsNothing);
  });
  testWidgets('TransformerPageView transformer only',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
        home: new TransformerPageView(
            transformer: new PageTransformerBuilder(
                builder: (Widget child, TransformInfo info) {
              return new Container(
                child: new Text("0"),
              );
            }),
            itemCount: 10)));

    // expect(find.text("0", skipOffstage: false), findsOneWidget);
  });

//  testWidgets('TransformerPageView animations', (WidgetTester tester) async {
//    // Build our app and trigger a frame.
//    await tester.pumpWidget(MaterialApp(
//        home: new TransformerPageView(
//            transformer: new ScaleAndFadeTransformer(),
//            itemBuilder: (context, index) {
//              return Text("0");
//            },
//            itemCount: 10)));
//
//    expect(find.text("0", skipOffstage: false), findsOneWidget);
//  });
//
//  testWidgets('TransformerPageView animations', (WidgetTester tester) async {
//    // Build our app and trigger a frame.
//    await tester.pumpWidget(MaterialApp(
//        home: new TransformerPageView(
//            transformer: new AccordionTransformer(),
//            itemBuilder: (context, index) {
//              return Text("0");
//            },
//            itemCount: 10)));
//
//    expect(find.text("0", skipOffstage: false), findsOneWidget);
//  });
//
//  testWidgets('TransformerPageView animations', (WidgetTester tester) async {
//    // Build our app and trigger a frame.
//    await tester.pumpWidget(MaterialApp(
//        home: new TransformerPageView(
//            transformer: new ZoomInPageTransformer(),
//            itemBuilder: (context, index) {
//              return Text("0");
//            },
//            itemCount: 10)));
//
//    expect(find.text("0", skipOffstage: false), findsOneWidget);
//  });
//
//  testWidgets('TransformerPageView animations', (WidgetTester tester) async {
//    // Build our app and trigger a frame.
//    await tester.pumpWidget(MaterialApp(
//        home: new TransformerPageView(
//            transformer: new ZoomOutPageTransformer(),
//            itemBuilder: (context, index) {
//              return Text("0");
//            },
//            itemCount: 10)));
//
//    expect(find.text("0", skipOffstage: false), findsOneWidget);
//  });
//
//  testWidgets('TransformerPageView animations', (WidgetTester tester) async {
//    // Build our app and trigger a frame.
//    await tester.pumpWidget(MaterialApp(
//        home: new TransformerPageView(
//            transformer: new ThreeDTransformer(),
//            itemBuilder: (context, index) {
//              return Text("0");
//            },
//            itemCount: 10)));
//
//    expect(find.text("0", skipOffstage: false), findsOneWidget);
//  });
//
//  testWidgets('TransformerPageView animations', (WidgetTester tester) async {
//    // Build our app and trigger a frame.
//    await tester.pumpWidget(MaterialApp(
//        home: new TransformerPageView(
//            transformer: new DeepthPageTransformer(),
//            itemBuilder: (context, index) {
//              return Text("0");
//            },
//            itemCount: 10)));
//
//    expect(find.text("0", skipOffstage: false), findsOneWidget);
//  });
//
  testWidgets('TransformerPageView controller', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    IndexController controller = new IndexController();

    await tester.pumpWidget(MaterialApp(
        home: new TransformerPageView(
            controller: controller,
            transformer: new FackTransformer(),
            itemBuilder: (context, index) {
              print("===================build:$index");
              return Text("$index");
            },
            itemCount: 10)));

    expect(find.text("0"), findsOneWidget);
    await controller.next(animation: false);

    expect(find.text("0"), findsOneWidget);
    await controller.previous(animation: false);
    expect(find.text("0"), findsOneWidget);
    await controller.move(2, animation: false);
    expect(find.text("0"), findsOneWidget);
  });
}

class FackTransformer extends PageTransformer {
  @override
  Widget transform(Widget child, TransformInfo info) {
    return child;
  }
}
