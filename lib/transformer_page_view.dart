library transformer_page_view;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:transformer_page_view/index_controller.dart';
export 'package:transformer_page_view/index_controller.dart';
export 'package:transformer_page_view/parallax.dart';

///
/// NOTICE::
///
/// In order to make package smaller,currently we're not supporting any build-in page transformers
/// You can find build in transforms here:
///
///
///

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

  /// Next `index` is greater than this `index`
  final bool forward;

  /// User drag is done.
  final bool done;

  /// Same as [TransformerPageView.viewportFraction]
  final double viewportFraction;

  /// Copy from [TransformerPageView.scrollDirection]
  final Axis scrollDirection;

  TransformInfo({
    required this.index,
    required this.position,
    required this.width,
    required this.height,
    required this.activeIndex,
    required this.fromIndex,
    required this.forward,
    required this.done,
    required this.viewportFraction,
    required this.scrollDirection,
  });
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

  PageTransformerBuilder({bool reverse: false, required this.builder})
      : super(reverse: reverse);

  @override
  Widget transform(Widget child, TransformInfo info) {
    return builder(child, info);
  }
}

class TransformerPageController extends PageController {
  final bool loop;
  final int itemCount;
  final bool reverse;

  TransformerPageController({
    int initialPage = 0,
    bool keepPage = true,
    double viewportFraction = 1.0,
    this.loop: false,
    required this.itemCount,
    this.reverse: false,
  }) : super(
            initialPage: TransformerPageController._getRealIndexFromRenderIndex(
                initialPage, loop, itemCount, reverse),
            keepPage: keepPage,
            viewportFraction: viewportFraction);

  int getRenderIndexFromRealIndex(int index) {
    return _getRenderIndexFromRealIndex(index, loop, itemCount, reverse);
  }

  int getRealItemCount() {
    if (itemCount == 0) return 0;
    return loop ? itemCount + kMaxValue : itemCount;
  }

  static _getRenderIndexFromRealIndex(
      int index, bool loop, int itemCount, bool reverse) {
    if (itemCount == 0) return 0;
    int renderIndex;
    if (loop) {
      renderIndex = index - kMiddleValue;
      renderIndex = renderIndex % itemCount;
      if (renderIndex < 0) {
        renderIndex += itemCount;
      }
    } else {
      renderIndex = index;
    }
    if (reverse) {
      renderIndex = itemCount - renderIndex - 1;
    }

    return renderIndex;
  }

  double get realPage {
    double page;
    // if (position.maxScrollExtent == null || position.minScrollExtent == null) {
    //   page = 0.0;
    // } else {
    page = super.page ?? 0.0;
    //}

    return page;
  }

  static _getRenderPageFromRealPage(
      double page, bool loop, int itemCount, bool reverse) {
    double renderPage;
    if (loop) {
      renderPage = page - kMiddleValue;
      renderPage = renderPage % itemCount;
      if (renderPage < 0) {
        renderPage += itemCount;
      }
    } else {
      renderPage = page;
    }
    if (reverse) {
      renderPage = itemCount - renderPage - 1;
    }

    return renderPage;
  }

  double get page {
    return loop
        ? _getRenderPageFromRealPage(realPage, loop, itemCount, reverse)
        : realPage;
  }

  int getRealIndexFromRenderIndex(int index) {
    return _getRealIndexFromRenderIndex(index, loop, itemCount, reverse);
  }

  static int _getRealIndexFromRenderIndex(
      int index, bool loop, int itemCount, bool reverse) {
    int result = reverse ? (itemCount - index - 1) : index;
    if (loop) {
      result += kMiddleValue;
    }
    return result;
  }
}

class TransformerPageView extends StatefulWidget {
  /// Create a `transformed` widget base on the widget that has been passed to  the [PageTransformer.transform].
  /// See [TransformInfo]
  ///
  final PageTransformer? transformer;

  /// Same as [PageView.scrollDirection]
  ///
  /// Defaults to [Axis.horizontal].
  final Axis scrollDirection;

  /// Same as [PageView.physics]
  final ScrollPhysics? physics;

  /// Set to false to disable page snapping, useful for custom scroll behavior.
  /// Same as [PageView.pageSnapping]
  final bool pageSnapping;

  /// Called whenever the page in the center of the viewport changes.
  /// Same as [PageView.onPageChanged]
  final ValueChanged<int>? onPageChanged;

  final IndexedWidgetBuilder? itemBuilder;

  // See [IndexController.mode],[IndexController.next],[IndexController.previous]
  final IndexController? controller;

  /// Animation duration
  final Duration duration;

  /// Animation curve
  final Curve curve;

  final TransformerPageController? pageController;

  /// Set true to open infinity loop mode.
  final bool loop;

  /// This value is only valid when `pageController` is not set,
  final int itemCount;

  /// This value is only valid when `pageController` is not set,
  final double viewportFraction;

  /// If not set, it is controlled by this widget.
  final int index;

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
    Key? key,
    this.index = 0,
    Duration? duration,
    this.curve: Curves.ease,
    this.viewportFraction: 1.0,
    this.loop: false,
    this.scrollDirection = Axis.horizontal,
    this.physics,
    this.pageSnapping = true,
    this.onPageChanged,
    this.controller,
    this.transformer,
    this.itemBuilder,
    this.pageController,
    required this.itemCount,
  })   : this.duration =
            duration ?? new Duration(milliseconds: kDefaultTransactionDuration),
        super(key: key);

  factory TransformerPageView.children({
    Key? key,
    int index = 0,
    Duration? duration,
    Curve curve: Curves.ease,
    double viewportFraction: 1.0,
    bool loop: false,
    Axis scrollDirection = Axis.horizontal,
    ScrollPhysics? physics,
    bool pageSnapping = true,
    ValueChanged<int>? onPageChanged,
    IndexController? controller,
    PageTransformer? transformer,
    required List<Widget> children,
    TransformerPageController? pageController,
  }) {
    return new TransformerPageView(
      itemCount: children.length,
      itemBuilder: (BuildContext context, int index) {
        return children[index];
      },
      pageController: pageController,
      transformer: transformer,
      pageSnapping: pageSnapping,
      key: key,
      index: index,
      duration: duration,
      curve: curve,
      viewportFraction: viewportFraction,
      scrollDirection: scrollDirection,
      physics: physics,
      onPageChanged: onPageChanged,
      controller: controller,
    );
  }

  @override
  State<StatefulWidget> createState() {
    return new _TransformerPageViewState();
  }

  static int getRealIndexFromRenderIndex({
    required bool reverse,
    required int index,
    required int itemCount,
    required bool loop,
  }) {
    int initPage = reverse ? (itemCount - index - 1) : index;
    if (loop) {
      initPage += kMiddleValue;
    }
    return initPage;
  }

  static PageController createPageController({
    required bool reverse,
    required int index,
    required int itemCount,
    required bool loop,
    required double viewportFraction,
  }) {
    return new PageController(
        initialPage: getRealIndexFromRenderIndex(
            reverse: reverse, index: index, itemCount: itemCount, loop: loop),
        viewportFraction: viewportFraction);
  }
}

class _TransformerPageViewState extends State<TransformerPageView> {
  Size? _size;
  late int _activeIndex;
  late double _currentPixels;
  bool _done = false;

  ///This value will not change until user end drag.
  late int _fromIndex;

  PageTransformer? _transformer;

  late TransformerPageController _pageController;

  Widget _buildItemNormal(BuildContext context, int index) {
    int renderIndex = _pageController.getRenderIndexFromRealIndex(index);
    Widget child = widget.itemBuilder!(context, renderIndex);
    return child;
  }

  Widget _buildItem(BuildContext context, int index) {
    return new AnimatedBuilder(
        animation: _pageController,
        builder: (BuildContext c, Widget? w) {
          int renderIndex = _pageController.getRenderIndexFromRealIndex(index);
          Widget? child;
          if (widget.itemBuilder != null) {
            child = widget.itemBuilder!(context, renderIndex);
          }
          if (child == null) {
            child = new Container();
          }
          if (_size == null) {
            return child;
          }

          double position;

          double page = _pageController.realPage;

          if (_transformer?.reverse ?? false) {
            position = page - index;
          } else {
            position = index - page;
          }
          position *= widget.viewportFraction;

          TransformInfo info = new TransformInfo(
              index: renderIndex,
              width: _size?.width ?? 0,
              height: _size?.height ?? 0,
              position: position.clamp(-1.0, 1.0),
              activeIndex:
                  _pageController.getRenderIndexFromRealIndex(_activeIndex),
              fromIndex: _fromIndex,
              forward: _pageController.position.pixels - _currentPixels >= 0,
              done: _done,
              scrollDirection: widget.scrollDirection,
              viewportFraction: widget.viewportFraction);
          return _transformer!.transform(child, info);
        });
  }

  double _calcCurrentPixels() {
    _currentPixels = _pageController.getRenderIndexFromRealIndex(_activeIndex) *
        _pageController.position.viewportDimension *
        widget.viewportFraction;

    //  print("activeIndex:$_activeIndex , pix:$_currentPixels");

    return _currentPixels;
  }

  @override
  Widget build(BuildContext context) {
    IndexedWidgetBuilder builder =
        _transformer == null ? _buildItemNormal : _buildItem;
    Widget child = new PageView.builder(
      itemBuilder: builder,
      itemCount: _pageController.getRealItemCount(),
      onPageChanged: _onIndexChanged,
      controller: _pageController,
      scrollDirection: widget.scrollDirection,
      physics: widget.physics,
      pageSnapping: widget.pageSnapping,
      reverse: _pageController.reverse,
    );
    if (_transformer == null) {
      return child;
    }
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
        child: child);
  }

  void _onIndexChanged(int index) {
    _activeIndex = index;
    if (widget.onPageChanged != null) {
      widget.onPageChanged!(_pageController.getRenderIndexFromRealIndex(index));
    }
  }

  void _onGetSize(_) {
    Size? size;
    // if (context == null) {
    //   onGetSize(size);
    //   return;
    // }
    RenderObject? renderObject = context.findRenderObject();
    if (renderObject != null) {
      Rect bounds = renderObject.paintBounds;
      //if (bounds != null) {
      size = bounds.size;
      //}
    } else {
      onGetSize(size);
      return;
    }
    _calcCurrentPixels();
    onGetSize(size);
  }

  void onGetSize(Size? size) {
    if (mounted) {
      setState(() {
        _size = size;
      });
    }
  }

  @override
  void initState() {
    _transformer = widget.transformer;
    //  int index = widget.index ?? 0;

    if (widget.pageController == null) {
      _pageController = new TransformerPageController(
          initialPage: widget.index,
          itemCount: widget.itemCount,
          loop: widget.loop,
          reverse: widget.transformer?.reverse ?? false);
    } else
      _pageController = widget.pageController!;

    // int initPage = _getRealIndexFromRenderIndex(index);
    // _pageController = new PageController(initialPage: initPage,viewportFraction: widget.viewportFraction);
    _fromIndex = _activeIndex = _pageController.initialPage;

    _controller = getNotifier();
    if (_controller != null) {
      _controller?.addListener(onChangeNotifier);
    }
    super.initState();
  }

  @override
  void didUpdateWidget(TransformerPageView oldWidget) {
    _transformer = widget.transformer;
    int index = widget.index;
    bool created = false;
    if (_pageController != widget.pageController) {
      if (widget.pageController != null) {
        _pageController = widget.pageController!;
      } else {
        created = true;
        _pageController = new TransformerPageController(
            initialPage: widget.index,
            itemCount: widget.itemCount,
            loop: widget.loop,
            reverse: widget.transformer?.reverse ?? false);
      }
    }

    if (_pageController.getRenderIndexFromRealIndex(_activeIndex) != index) {
      _fromIndex = _activeIndex = _pageController.initialPage;
      if (!created) {
        int initPage = _pageController.getRealIndexFromRenderIndex(index);
        _pageController.animateToPage(initPage,
            duration: widget.duration, curve: widget.curve);
      }
    }
    if (_transformer != null)
      WidgetsBinding.instance?.addPostFrameCallback(_onGetSize);

    if (_controller != getNotifier()) {
      if (_controller != null) {
        _controller?.removeListener(onChangeNotifier);
      }
      _controller = getNotifier();
      if (_controller != null) {
        _controller?.addListener(onChangeNotifier);
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    if (_transformer != null)
      WidgetsBinding.instance?.addPostFrameCallback(_onGetSize);
    super.didChangeDependencies();
  }

  ChangeNotifier? getNotifier() {
    return widget.controller;
  }

  int _calcNextIndex(bool next) {
    int currentIndex = _activeIndex;
    if (_pageController.reverse) {
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

    if (!_pageController.loop) {
      if (currentIndex >= _pageController.itemCount) {
        currentIndex = 0;
      } else if (currentIndex < 0) {
        currentIndex = _pageController.itemCount - 1;
      }
    }

    return currentIndex;
  }

  void onChangeNotifier() {
    int event = widget.controller!.event;
    int index;
    switch (event) {
      case IndexController.MOVE:
        {
          index = _pageController
              .getRealIndexFromRenderIndex(widget.controller!.index);
        }
        break;
      case IndexController.PREVIOUS:
      case IndexController.NEXT:
        {
          index = _calcNextIndex(event == IndexController.NEXT);
        }
        break;
      default:
        //ignore this event
        return;
    }
    if (widget.controller!.animation) {
      _pageController
          .animateToPage(index, duration: widget.duration, curve: widget.curve)
          .whenComplete(widget.controller!.complete);
    } else {
      _pageController.jumpToPage(index);
      widget.controller?.complete();
    }
  }

  ChangeNotifier? _controller;

  void dispose() {
    super.dispose();
    if (_controller != null) {
      _controller?.removeListener(onChangeNotifier);
    }
  }
}

class WarmPainter extends BasePainter {
  WarmPainter(PageIndicator widget, double page, int index, Paint paint)
      : super(widget, page, index, paint);

  void draw(Canvas canvas, double space, double size, double radius) {
    double progress = page - index;
    double distance = size + space;
    double start = index * (size + space);

    if (progress > 0.5) {
      double right = start + size + distance;
      //progress=>0.5-1.0
      //left:0.0=>distance

      double left = index * distance + distance * (progress - 0.5) * 2;
      canvas.drawRRect(
          new RRect.fromLTRBR(
              left, 0.0, right, size, new Radius.circular(radius)),
          _paint);
    } else {
      double right = start + size + distance * progress * 2;

      canvas.drawRRect(
          new RRect.fromLTRBR(
              start, 0.0, right, size, new Radius.circular(radius)),
          _paint);
    }
  }
}

class DropPainter extends BasePainter {
  DropPainter(PageIndicator widget, double page, int index, Paint paint)
      : super(widget, page, index, paint);

  @override
  void draw(Canvas canvas, double space, double size, double radius) {
    double progress = page - index;
    double dropHeight = widget.dropHeight;
    double rate = (0.5 - progress).abs() * 2;
    double scale = widget.scale;

    //lerp(begin, end, progress)

    canvas.drawCircle(
        new Offset(radius + ((page) * (size + space)),
            radius - dropHeight * (1 - rate)),
        radius * (scale + rate * (1.0 - scale)),
        _paint);
  }
}

class NonePainter extends BasePainter {
  NonePainter(PageIndicator widget, double page, int index, Paint paint)
      : super(widget, page, index, paint);

  @override
  void draw(Canvas canvas, double space, double size, double radius) {
    double progress = page - index;
    double secondOffset = index == widget.count - 1
        ? radius
        : radius + ((index + 1) * (size + space));

    if (progress > 0.5) {
      canvas.drawCircle(new Offset(secondOffset, radius), radius, _paint);
    } else {
      canvas.drawCircle(new Offset(radius + (index * (size + space)), radius),
          radius, _paint);
    }
  }
}

class SlidePainter extends BasePainter {
  SlidePainter(PageIndicator widget, double page, int index, Paint paint)
      : super(widget, page, index, paint);

  @override
  void draw(Canvas canvas, double space, double size, double radius) {
    canvas.drawCircle(
        new Offset(radius + (page * (size + space)), radius), radius, _paint);
  }
}

class ScalePainter extends BasePainter {
  ScalePainter(PageIndicator widget, double page, int index, Paint paint)
      : super(widget, page, index, paint);

  // 连续的两个点，含有最后一个和第一个
  @override
  bool _shouldSkip(int i) {
    if (index == widget.count - 1) {
      return i == 0 || i == index;
    }
    return (i == index || i == index + 1);
  }

  @override
  void paint(Canvas canvas, Size size) {
    _paint.color = widget.color;
    double space = widget.space;
    double size = widget.size;
    double radius = size / 2;
    for (int i = 0, c = widget.count; i < c; ++i) {
      if (_shouldSkip(i)) {
        continue;
      }
      canvas.drawCircle(new Offset(i * (size + space) + radius, radius),
          radius * widget.scale, _paint);
    }

    _paint.color = widget.activeColor;
    draw(canvas, space, size, radius);
  }

  @override
  void draw(Canvas canvas, double space, double size, double radius) {
    double secondOffset = index == widget.count - 1
        ? radius
        : radius + ((index + 1) * (size + space));

    double progress = page - index;
    _paint.color = Color.lerp(widget.activeColor, widget.color, progress) ??
        Colors.transparent;
    //last
    canvas.drawCircle(new Offset(radius + (index * (size + space)), radius),
        lerp(radius, radius * widget.scale, progress), _paint);
    //first
    _paint.color = Color.lerp(widget.color, widget.activeColor, progress) ??
        Colors.transparent;
    canvas.drawCircle(new Offset(secondOffset, radius),
        lerp(radius * widget.scale, radius, progress), _paint);
  }
}

class ColorPainter extends BasePainter {
  ColorPainter(PageIndicator widget, double page, int index, Paint paint)
      : super(widget, page, index, paint);

  // 连续的两个点，含有最后一个和第一个
  @override
  bool _shouldSkip(int i) {
    if (index == widget.count - 1) {
      return i == 0 || i == index;
    }
    return (i == index || i == index + 1);
  }

  @override
  void draw(Canvas canvas, double space, double size, double radius) {
    double progress = page - index;
    double secondOffset = index == widget.count - 1
        ? radius
        : radius + ((index + 1) * (size + space));

    _paint.color = Color.lerp(widget.activeColor, widget.color, progress) ??
        Colors.transparent;
    //left
    canvas.drawCircle(
        new Offset(radius + (index * (size + space)), radius), radius, _paint);
    //right
    _paint.color = Color.lerp(widget.color, widget.activeColor, progress) ??
        Colors.transparent;
    canvas.drawCircle(new Offset(secondOffset, radius), radius, _paint);
  }
}

abstract class BasePainter extends CustomPainter {
  final PageIndicator widget;
  final double page;
  final int index;
  final Paint _paint;

  double lerp(double begin, double end, double progress) {
    return begin + (end - begin) * progress;
  }

  BasePainter(this.widget, this.page, this.index, this._paint);

  void draw(Canvas canvas, double space, double size, double radius);

  bool _shouldSkip(int index) {
    return false;
  }
  //double secondOffset = index == widget.count-1 ? radius : radius + ((index + 1) * (size + space));

  @override
  void paint(Canvas canvas, Size size) {
    _paint.color = widget.color;
    double space = widget.space;
    double size = widget.size;
    double radius = size / 2;
    for (int i = 0, c = widget.count; i < c; ++i) {
      if (_shouldSkip(i)) {
        continue;
      }
      canvas.drawCircle(
          new Offset(i * (size + space) + radius, radius), radius, _paint);
    }

    double page = this.page;
    if (page < index) {
      page = 0.0;
    }
    _paint.color = widget.activeColor;
    draw(canvas, space, size, radius);
  }

  @override
  bool shouldRepaint(BasePainter oldDelegate) {
    return oldDelegate.page != page;
  }
}

class _PageIndicatorState extends State<PageIndicator> {
  int index = 0;
  Paint _paint = new Paint();

  BasePainter _createPainer() {
    switch (widget.layout) {
      case PageIndicatorLayout.NONE:
        return new NonePainter(
            widget, widget.controller.page ?? 0.0, index, _paint);
      case PageIndicatorLayout.SLIDE:
        return new SlidePainter(
            widget, widget.controller.page ?? 0.0, index, _paint);
      case PageIndicatorLayout.WARM:
        return new WarmPainter(
            widget, widget.controller.page ?? 0.0, index, _paint);
      case PageIndicatorLayout.COLOR:
        return new ColorPainter(
            widget, widget.controller.page ?? 0.0, index, _paint);
      case PageIndicatorLayout.SCALE:
        return new ScalePainter(
            widget, widget.controller.page ?? 0.0, index, _paint);
      case PageIndicatorLayout.DROP:
        return new DropPainter(
            widget, widget.controller.page ?? 0.0, index, _paint);
      default:
        throw new Exception("Not a valid layout");
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = new SizedBox(
      width: widget.count * widget.size + (widget.count - 1) * widget.space,
      height: widget.size,
      child: new CustomPaint(
        painter: _createPainer(),
      ),
    );

    if (widget.layout == PageIndicatorLayout.SCALE ||
        widget.layout == PageIndicatorLayout.COLOR) {
      child = new ClipRect(
        child: child,
      );
    }

    return new IgnorePointer(
      child: child,
    );
  }

  void _onController() {
    double page = widget.controller.page ?? 0.0;
    index = page.floor();

    setState(() {});
  }

  @override
  void initState() {
    widget.controller.addListener(_onController);
    super.initState();
  }

  @override
  void didUpdateWidget(PageIndicator oldWidget) {
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_onController);
      widget.controller.addListener(_onController);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onController);
    super.dispose();
  }
}

enum PageIndicatorLayout {
  NONE,
  SLIDE,
  WARM,
  COLOR,
  SCALE,
  DROP,
}

class PageIndicator extends StatefulWidget {
  /// size of the dots
  final double size;

  /// space between dots.
  final double space;

  /// count of dots
  final int count;

  /// active color
  final Color activeColor;

  /// normal color
  final Color color;

  /// layout of the dots,default is [PageIndicatorLayout.SLIDE]
  final PageIndicatorLayout layout;

  // Only valid when layout==PageIndicatorLayout.scale
  final double scale;

  // Only valid when layout==PageIndicatorLayout.drop
  final double dropHeight;

  final PageController controller;

  final double activeSize;

  PageIndicator(
      {Key? key,
      this.size: 20.0,
      this.space: 5.0,
      required this.count,
      this.activeSize: 20.0,
      required this.controller,
      this.color: Colors.white30,
      this.layout: PageIndicatorLayout.SLIDE,
      this.activeColor: Colors.white,
      this.scale: 0.6,
      this.dropHeight: 20.0})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _PageIndicatorState();
  }
}
