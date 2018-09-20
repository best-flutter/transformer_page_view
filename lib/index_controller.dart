import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

abstract class ChangeNotifierMixin<T extends StatefulWidget> extends State<T> {
  ChangeNotifier _controller;

  @override
  void initState() {
    _controller = getNotifier();
    if (_controller != null) {
      _controller.addListener(onChangeNotifier);
    }

    super.initState();
  }

  void onChangeNotifier();

  @override
  void dispose() {
    if (_controller != null) {
      _controller.removeListener(onChangeNotifier);
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(T oldWidget) {
    if (_controller != getNotifier()) {
      if (_controller != null) {
        _controller.removeListener(onChangeNotifier);
      }
      _controller = getNotifier();
      if (_controller != null) {
        _controller.addListener(onChangeNotifier);
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  ChangeNotifier getNotifier();
}

class IndexController extends ChangeNotifier {
  static const int NEXT = 1;
  static const int PREVIOUS = -1;
  static const int MOVE = 0;


  Completer _completer;

  int index;
  bool animation;
  int event;

  Future move(int index, {bool animation: true}) {
    this.animation = animation ?? true;
    this.index = index;
    this.event = MOVE;
    _completer = new Completer();
    notifyListeners();
    return _completer.future;
  }

  Future next({bool animation: true}) {
    this.event = NEXT;
    this.animation = animation ?? true;
    _completer = new Completer();
    notifyListeners();
    return _completer.future;
  }

  Future previous({bool animation: true}) {
    this.event = PREVIOUS;
    this.animation = animation ?? true;
    _completer = new Completer();
    notifyListeners();
    return _completer.future;
  }

  void complete(){
    if(! _completer.isCompleted){
      _completer.complete();
    }
  }
}
