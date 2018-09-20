
<p align="center">
    <a href="https://travis-ci.org/best-flutter/transformer_page_view">
        <img src="https://travis-ci.org/best-flutter/transformer_page_view.svg?branch=master" alt="Build Status" />
    </a>
    <a href="https://github.com/best-flutter/transformer_page_view/pulls">
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

### Parallax

![Welcome view](https://github.com/jzoom/images/raw/master/welcome.gif)


### Basic

![AccordionTransformer](https://github.com/jzoom/images/raw/master/AccordionTransformer.gif)

>See code [here](https://github.com/best-flutter/transformer_page_view/blob/master/example/lib/AccordionTransformer.dart)

![ThreeDTransformer](https://github.com/jzoom/images/raw/master/ThreeDTransformer.gif)

>See code [here](https://github.com/best-flutter/transformer_page_view/blob/master/example/lib/ThreeDTransformer.dart)


![ScaleAndFadeTransformer](https://github.com/jzoom/images/raw/master/ScaleAndFadeTransformer.gif)

>See code [here](https://github.com/best-flutter/transformer_page_view/blob/master/example/lib/ScaleAndFadeTransformers.dart)


![ZoomInPageTransformer](https://github.com/jzoom/images/raw/master/ZoomInPageTransformer.gif)

>See code [here](https://github.com/best-flutter/transformer_page_view/blob/master/example/lib/ZoomInPageTransformer.dart)


![ZoomOutPageTransformer](https://github.com/jzoom/images/raw/master/ZoomOutPageTransformer.gif)

>See code [here](https://github.com/best-flutter/transformer_page_view/blob/master/example/lib/ZoomOutPageTransformer.dart)


![DepthPageTransformer](https://github.com/jzoom/images/raw/master/DepthPageTransformer.gif)

>See code [here](https://github.com/best-flutter/transformer_page_view/blob/master/example/lib/DepthPageTransformers.dart)





## Getting Started

- [Installation](#installation)
- [Basic Usage](#basic-usage)
- [Build-in Parallax](#build-in-parallax)
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


### Basic Usage


| Parameter  | Default   | Description |
| :------------ |:---------------:| :-----|
| scrollDirection | Axis.horizontal  | If `Axis.horizontal`, the scroll view's children are arranged horizontally in a row instead of vertically in a column. |
| loop | false |Set to `true` to enable continuous loop mode. |
| index | none |  Index number of initial slide. if not set , it is controlled by the widget itself,otherwise, it is controlled by another widget, which is returned by `itemBuilder`|
| onPageChanged | void onPageChanged(int index)  | Called with the new index when the user swiped |
| duration | new Duration(milliseconds:300) | The milliseconds of every transaction animation costs  |
| transformer | none | The most important property of this widget, it returns a `transformed` widget that based on the widget parameter. If the value is null, a `itemBuilder` must be specified |
| itemCount | none | Number of the total items  |
| itemBuilder | none | A function that returns a widget based on index,if it's null,a `transformer` must be specified |


### Build-in Parallax

We provide 3 build-in parallaxes, which handle color、image and container

> ParallaxColor

ParallaxColor handles the color transform, which controls the color transform from one to another. 

> ParallaxImage

ParallaxImage handles the image, which speed is slower than the `PageView`

> ParallaxContainer

ParallaxContainer handles the text or other staff, which speed is faster than the `PageView`

3 build-in parallaxes are all used in subclass of `PageTransform`,group these parallaxes together, we can create very cool things.

![](https://github.com/jzoom/images/raw/master/beauty.gif)

Inspired by [page-transformer](https://github.com/roughike/page-transformer), and we have an easier way to create this.

>See code [here](https://github.com/best-flutter/transformer_page_view/blob/master/example/lib/images.dart)

### Custom animation








