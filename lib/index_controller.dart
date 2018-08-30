import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';



abstract class ChangeNotifierMixin<T extends StatefulWidget> extends State<T>{

  ChangeNotifier _controller;

  @override
  void initState() {
    _controller = getNotifier();
    if(_controller != null ){
      _controller.addListener(onChangeNotifier);
    }

    super.initState();
  }

  void onChangeNotifier();

  @override
  void dispose() {
    if(_controller!= null ){
      _controller.removeListener(onChangeNotifier);
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(T oldWidget) {
    if(_controller != getNotifier()){
      if(_controller!= null ){
        _controller.removeListener(onChangeNotifier);
      }
      _controller = getNotifier();
      if(_controller != null ){
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

  int index;
  bool animation;
  int event;

  void move(int index, {bool animation: true}) {
    this.animation = animation;
    this.index = index;
    this.event = MOVE;
    notifyListeners();
  }

  void next({bool animation: true}) {
    this.event = NEXT;
    this.animation = animation;
    notifyListeners();
  }

  void previous({bool animation: true}) {
    this.event = PREVIOUS;
    this.animation = animation;
    notifyListeners();
  }
}
