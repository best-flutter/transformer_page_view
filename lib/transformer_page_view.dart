library transformer_page_view;

import 'package:flutter/widgets.dart';
import 'dart:math' as Math;
import 'package:transformer_page_view/index_controller.dart';
import 'package:vector_math/vector_math_64.dart';

export 'package:transformer_page_view/index_controller.dart';
export 'package:transformer_page_view/parallax.dart';

part 'transformers.dart';

const int kMaxValue = 2000000000;
const int kMiddleValue = 1000000000;

///  Default auto play transition duration (in millisecond)
const int kDefaultTransactionDuration = 300;

class TransformInfo {
  /// The `width` of the `TransformerPageView`
  final double width;

  /// The `height` of the `TransformerPageView`
  final double height;

  /// The `position` of the widget pass to [PageTransformer.transform]
  ///  A `position` describes how visible the widget is.
  ///  The widget in the center of the screen' which is  full visible, position is 0.0.
  ///  The widge in the left ,may be hidden, of the screen's position is less than 0.0, -1.0 when out of the screen.
  ///  The widge in the right ,may be hidden, of the screen's position is greater than 0.0,  1.0 when out of the screen
  ///
  ///
  final double position;

  /// The `index` of the widget pass to [PageTransformer.transform]
  final int index;

  /// The `activeIndex` of the PageView
  final int activeIndex;

  /// The `activeIndex` of the PageView, from user start to swipe
  /// It will change when user end drag
  final int fromIndex;

  ///
  final bool forward;

  /// User drag is done.
  final bool done;

  /// Same as [TransformerPageView.viewportFraction]
  final double viewportFraction;

  /// Copy from [TransformerPageView.scrollDirection]
  final Axis scrollDirection;

  TransformInfo(
      {this.index,
      this.position,
      this.width,
      this.height,
      this.activeIndex,
      this.fromIndex,
      this.forward,
      this.done,
      this.viewportFraction,
      this.scrollDirection});
}

abstract class PageTransformer {
  ///
  final bool reverse;

  PageTransformer({this.reverse: false});

  /// Return a transformed widget, based on child and TransformInfo
  Widget transform(Widget child, TransformInfo info);
}

typedef Widget PageTransformerBuilderCallback(Widget child, TransformInfo info);

class PageTransformerBuilder extends PageTransformer {
  final PageTransformerBuilderCallback builder;

  PageTransformerBuilder({bool reverse: false, @required this.builder})
      : assert(builder != null),
        super(reverse: reverse);

  @override
  Widget transform(Widget child, TransformInfo info) {
    return builder(child, info);
  }
}

class TransformerPageView extends StatefulWidget {
  /// Create a `transformed` widget base on the widget that has been passed to  the [PageTransformer.transform].
  /// See [TransformInfo]
  ///
  final PageTransformer transformer;

  /// Same as [PageView.scrollDirection]
  ///
  /// Defaults to [Axis.horizontal].
  final Axis scrollDirection;

  /// Set true to open infinity loop mode.
  final bool loop;

  /// Same as [PageView.physics]
  final ScrollPhysics physics;

  /// Set to false to disable page snapping, useful for custom scroll behavior.
  /// Same as [PageView.pageSnapping]
  final bool pageSnapping;

  /// Called whenever the page in the center of the viewport changes.
  /// Same as [PageView.onPageChanged]
  final ValueChanged<int> onPageChanged;

  final IndexedWidgetBuilder itemBuilder;

  final int itemCount;

  final int index;

  final IndexController controller;

  final double viewportFraction;

  /// Animation duration
  final Duration duration;

  /// Animation curve
  final Curve curve;

  /// Notice : This value is not the same as [PageView.reverse]
  /// It is copy from [PageTransformer.reverse],
  final bool reverse;

  /// Creates a scrollable list that works page by page using widgets that are
  /// created on demand.
  ///
  /// This constructor is appropriate for page views with a large (or infinite)
  /// number of children because the builder is called only for those children
  /// that are actually visible.
  ///
  /// Providing a non-null [itemCount] lets the [PageView] compute the maximum
  /// scroll extent.
  ///
  /// [itemBuilder] will be called only with indices greater than or equal to
  /// zero and less than [itemCount].
  TransformerPageView({
    Key key,
    this.index: 0,
    Duration duration,
    this.curve,
    this.viewportFraction: 1.0,
    this.loop: false,
    this.scrollDirection = Axis.horizontal,
    this.physics,
    this.pageSnapping = true,
    this.onPageChanged,
    this.controller,
    this.transformer,
    this.itemBuilder,
    @required this.itemCount,
  })  : assert(itemBuilder != null || transformer != null),
        this.reverse = transformer == null ? false : transformer.reverse,
        this.duration =
            duration ?? new Duration(milliseconds: kDefaultTransactionDuration),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _TransformerPageViewState();
  }
}

class _TransformerPageViewState extends State<TransformerPageView>
    with ChangeNotifierMixin<TransformerPageView> {
  Size _size;
  int _activeIndex;
  PageController _pageController;
  double _currentPixels;
  bool _done = false;

  ///This value will not change until user end drag.
  int _fromIndex;

  PageTransformer _transformer;

  int _itemCount;

  double get page {
    if (_pageController.position.maxScrollExtent == null ||
        _pageController.position.minScrollExtent == null) {
      return 0.0;
    }
    return _pageController.page;
  }

  int _getRenderIndex(int index) {
    int renderIndex;
    if (widget.loop) {
      renderIndex = index - kMiddleValue;
      renderIndex = renderIndex % widget.itemCount;
      if (renderIndex < 0) {
        renderIndex += widget.itemCount;
      }
    } else {
      renderIndex = index;
    }
    if (widget.reverse) {
      renderIndex = widget.itemCount - renderIndex - 1;
    }

    return renderIndex;
  }

  Widget _buildItemNormal(BuildContext context, int index) {
    int renderIndex = _getRenderIndex(index);
    Widget child = widget.itemBuilder(context, renderIndex);
    return child;
  }

  Widget _buildItem(BuildContext context, int index) {
    return new AnimatedBuilder(
        animation: _pageController,
        builder: (BuildContext c, Widget w) {
          int renderIndex = _getRenderIndex(index);
          Widget child;
          if (widget.itemBuilder != null) {
            child = widget.itemBuilder(context, renderIndex);
          }
          if (child == null) {
            child = new Container();
          }
          if (_size == null) {
            return child ?? new Container();
          }

          double position;

          double page = this.page;

          if (_transformer.reverse) {
            position = page - index;
          } else {
            position = index - page;
          }
          position *= widget.viewportFraction;

          TransformInfo info = new TransformInfo(
              index: renderIndex,
              width: _size.width,
              height: _size.height,
              position: position.clamp(-1.0, 1.0),
              activeIndex: _getRenderIndex(_activeIndex),
              fromIndex: _fromIndex,
              forward: _pageController.position.pixels - _currentPixels >= 0,
              done: _done,
              scrollDirection: widget.scrollDirection,
              viewportFraction: widget.viewportFraction);
          return _transformer.transform(child, info);
        });
  }

  double _calcCurrentPixels() {
    _currentPixels = _getRenderIndex(_activeIndex) *
        _pageController.position.viewportDimension *
        widget.viewportFraction;

  //  print("activeIndex:$_activeIndex , pix:$_currentPixels");

    return _currentPixels;
  }

  @override
  Widget build(BuildContext context) {
    IndexedWidgetBuilder builder =
        _transformer == null ? _buildItemNormal : _buildItem;
    return new NotificationListener(
        onNotification: (ScrollNotification notification) {
          if (notification is ScrollStartNotification) {
            _calcCurrentPixels();
            _done = false;
            _fromIndex = _activeIndex;
          } else if (notification is ScrollEndNotification) {
            _calcCurrentPixels();
            _fromIndex = _activeIndex;
            _done = true;
          }

          return false;
        },
        child: new PageView.builder(
          itemBuilder: builder,
          itemCount: _itemCount,
          onPageChanged: _onIndexChanged,
          controller: _pageController,
          scrollDirection: widget.scrollDirection,
          physics: widget.physics,
          pageSnapping: widget.pageSnapping,
          reverse: widget.reverse,
        ));
  }

  void _onIndexChanged(int index) {
    _activeIndex = index;
  }

  void _onGetSize(_) {
    RenderObject renderObject = context.findRenderObject();
    Size size = renderObject?.paintBounds?.size;
    _calcCurrentPixels();
    onGetSize(size);
  }

  void onGetSize(Size size) {
    setState(() {
      _size = size;
    });
  }

  int _getInitPage() {
    int initPage =
        widget.reverse ? (widget.itemCount - widget.index - 1) : widget.index;
    if (widget.loop) {
      initPage += kMiddleValue;
    }
    return initPage;
  }

  @override
  void initState() {
    _transformer = widget.transformer;
    int initPage = _getInitPage();
    _itemCount = widget.loop ? widget.itemCount + kMaxValue : widget.itemCount;
    _pageController = new PageController(
        initialPage: initPage, viewportFraction: widget.viewportFraction);
    _fromIndex = _activeIndex = initPage;

    super.initState();
  }

  @override
  void didUpdateWidget(TransformerPageView oldWidget) {
    _transformer = widget.transformer;
    int initPage = _getInitPage();
    _itemCount = widget.loop ? widget.itemCount + kMaxValue : widget.itemCount;
    bool created = false;
    if (widget.viewportFraction != _pageController.viewportFraction) {
      _pageController = new PageController(
          initialPage: initPage, viewportFraction: widget.viewportFraction);
      created = true;
    }
    if (_activeIndex != initPage) {
      _fromIndex = _activeIndex = initPage;
      if (!created)
        _pageController.animateToPage(initPage,
            duration: widget.duration, curve: Curves.ease);
    }

    WidgetsBinding.instance.addPostFrameCallback(_onGetSize);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback(_onGetSize);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  ChangeNotifier getNotifier() {
    return widget.controller;
  }

  int _calcNextIndex(bool next) {
    int currentIndex = _activeIndex;
    if (widget.reverse) {
      if (next) {
        currentIndex--;
      } else {
        currentIndex++;
      }
    } else {
      if (next) {
        currentIndex++;
      } else {
        currentIndex--;
      }
    }
    return currentIndex;
  }

  @override
  void onChangeNotifier() {
    switch (widget.controller.event) {
      case IndexController.MOVE:
        break;
      case IndexController.PREVIOUS:
        {
          _pageController.animateToPage(_calcNextIndex(false),
              duration: widget.duration, curve: widget.curve ?? Curves.ease);
        }

        break;
      case IndexController.NEXT:
        {
          _pageController.animateToPage(_calcNextIndex(true),
              duration: widget.duration, curve: widget.curve ?? Curves.ease);
        }
        break;
    }
  }
}
