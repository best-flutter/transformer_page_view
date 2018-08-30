
<p align="center">
    <a href="https://travis-ci.org/jzoom/transformer_page_view">
        <img src="https://travis-ci.org/jzoom/transformer_page_view.svg?branch=master" alt="Build Status" />
    </a>
    <a href="https://coveralls.io/github/jzoom/transformer_page_view?branch=master">
        <img src="https://coveralls.io/repos/github/jzoom/transformer_page_view/badge.svg?branch=master" alt="Coverage Status" />
    </a>
    <a href="https://github.com/jzoom/transformer_page_view/pulls">
        <img src="https://img.shields.io/badge/PRs-Welcome-brightgreen.svg" alt="PRs Welcome" />
    </a>
    <a href="https://pub.dartlang.org/packages/transformer_page_view">
        <img src="https://img.shields.io/pub/v/transformer_page_view.svg" alt="pub package" />
    </a>
</p>

# transformer_page_view

PageTransformer for flutter


## Very simple to use


```
import 'package:transformer_page_view/transformer_page_view.dart';

...

new TransformerPageView(
loop: true,
transformer: new AccordionTransformer(),
itemBuilder: (BuildContext context, int index) {
  return new Container(
    color: list[index%list.length],
    child: new Center(
      child: new Text("$index",style: new TextStyle(fontSize: 80.0,color: Colors.white),),
    ),
  );
},
itemCount: 3)
```

Almost the same as PageView.builder, simplely specify a `transformer` to `TransformerPageView`, 
    which is a sub class of `PageTransformer`


## Show cases


### Basic

![AccordionTransformer](https://github.com/jzoom/images/raw/master/AccordionTransformer.gif)

>See code [here](https://github.com/jzoom/transformer_page_view/blob/master/example/lib/AccordionTransformer.dart)

![ThreeDTransformer](https://github.com/jzoom/images/raw/master/ThreeDTransformer.gif)

>See code [here](https://github.com/jzoom/transformer_page_view/blob/master/example/lib/ThreeDTransformer.dart)


![ScaleAndFadeTransformer](https://github.com/jzoom/images/raw/master/ScaleAndFadeTransformer.gif)

>See code [here](https://github.com/jzoom/transformer_page_view/blob/master/example/lib/ScaleAndFadeTransformers.dart)


![ZoomInPageTransformer](https://github.com/jzoom/images/raw/master/ZoomInPageTransformer.gif)

>See code [here](https://github.com/jzoom/transformer_page_view/blob/master/example/lib/ZoomInPageTransformer.dart)


![ZoomOutPageTransformer](https://github.com/jzoom/images/raw/master/ZoomOutPageTransformer.gif)

>See code [here](https://github.com/jzoom/transformer_page_view/blob/master/example/lib/ZoomOutPageTransformer.dart)


![DepthPageTransformer](https://github.com/jzoom/images/raw/master/DepthPageTransformer.gif)

>See code [here](https://github.com/jzoom/transformer_page_view/blob/master/example/lib/DepthPageTransformers.dart)



### Parallax



## Getting Started

- [Installation](#installation)
- [Basic Usage](#basic-usage)
- [Properties](#properties)
- [Build in animations](#build-in-animations)
- [Custom animation](#custom-animation)


### Installation

Add 

```bash

transformer_page_view:

```
to your pubspec.yaml ,and run 

```bash
flutter packages get 
```
in your project's root directory.

