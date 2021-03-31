import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'dart:math';

class MyViewPort extends RenderSliverFillViewport {
  int itemCount;

  MyViewPort(
      {@required RenderSliverBoxChildManager childManager,
      double viewportFraction = 1.0,
      this.itemCount})
      : super(childManager: childManager, viewportFraction: viewportFraction);

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset, double itemExtent) {
    return min(
        super.getMaxChildIndexForScrollOffset(scrollOffset, itemExtent) + 2,
        itemCount - 1);
  }

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset, double itemExtent) {
    return super.getMinChildIndexForScrollOffset(scrollOffset, itemExtent);
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! SliverMultiBoxAdaptorParentData)
      child.parentData = new SliverMultiBoxAdaptorParentData()
        ..keepAlive = true;
  }
}

class MySliverFillViewport extends SliverMultiBoxAdaptorWidget {
  /// Creates a sliver whose box children that each fill the viewport.
  //
  const MySliverFillViewport(
      {Key key,
      @required SliverChildDelegate delegate,
      this.viewportFraction = 1.0,
      this.itemCount})
      : assert(viewportFraction != null),
        assert(viewportFraction > 0.0),
        super(key: key, delegate: delegate);

  /// The fraction of the viewport that each child should fill in the main axis.
  ///
  /// If this fraction is less than 1.0, more than one child will be visible at
  /// once. If this fraction is greater than 1.0, each child will be larger than
  /// the viewport in the main axis.
  final double viewportFraction;

  final int itemCount;

  @override
  RenderSliverFillViewport createRenderObject(BuildContext context) {
    final SliverMultiBoxAdaptorElement element = context;
    return new MyViewPort(
        childManager: element,
        itemCount: itemCount,
        viewportFraction: viewportFraction);
  }

  @override
  SliverMultiBoxAdaptorElement createElement() {
    return new SliverMultiBoxAdaptorElement(this);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderSliverFillViewport renderObject) {
    renderObject.viewportFraction = viewportFraction;
  }
}

const PageScrollPhysics _kPagePhysics = PageScrollPhysics();

class Ext extends PageView {}

// ignore: must_be_immutable
class MyPageView extends StatelessWidget {
  final SliverChildListDelegate childrenDelegate;

  MyPageView({List<Widget> children})
      : childrenDelegate = new SliverChildListDelegate(children);

  PageController controller = new PageController();

  Widget build(BuildContext context) {
    return new Scrollable(
      axisDirection: AxisDirection.right,
      controller: controller,
      physics: _kPagePhysics,
      viewportBuilder: (BuildContext context, ViewportOffset position) {
        print(position);
        return new Viewport(
          cacheExtent: 300.0,
          axisDirection: AxisDirection.right,
          offset: position,
          slivers: <Widget>[
            new MySliverFillViewport(
                viewportFraction: 1.0,
                itemCount: 10,
                delegate: childrenDelegate),
          ],
        );
      },
    );
  }
}
