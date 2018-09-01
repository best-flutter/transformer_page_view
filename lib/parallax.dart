import 'package:flutter/widgets.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

typedef void PaintCallback(Canvas canvas, Size siz);

class MyCustomPainter extends CustomPainter {
  final PaintCallback callback;

  MyCustomPainter({this.callback});

  @override
  void paint(Canvas canvas, Size size) {
    callback(canvas, size);
  }

  @override
  bool shouldRepaint(MyCustomPainter oldDelegate) {
    return oldDelegate.callback != callback;
  }
}

class CustomPaintBuilder extends StatelessWidget {
  final PaintCallback callback;
  final Widget child;

  CustomPaintBuilder(this.callback, {this.child});

  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      painter: new MyCustomPainter(callback: callback),
      child: child,
    );
  }
}


class ParallaxColor extends StatelessWidget {
  final Widget child;

  final List<Color> colors;

  final TransformInfo info;

  ParallaxColor({
    @required this.colors,
    @required this.info,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return new CustomPaintBuilder(
      (Canvas canvas, Size size) {
        Paint paint = new Paint();
        int index = info.fromIndex;
        paint.color = colors[index];
        canvas.drawRect(
            new Rect.fromLTWH(0.0, 0.0, size.width, size.height), paint);
        if (info.done) {
          return;
        }
        int alpha;
        int color;
        double opacity;
        double position = info.position;
        if (info.forward) {
          if (index < colors.length - 1) {
            color = colors[index + 1].value & 0x00ffffff;
            opacity = (position <= 0 ? -position : 1 - position);
            alpha = (0xff * opacity).toInt();

            paint.color = new Color((alpha << 24) | color);
            canvas.drawRect(
                new Rect.fromLTWH(0.0, 0.0, size.width, size.height), paint);
          }
        } else {
          if (index > 0) {
            color = colors[index - 1].value & 0x00ffffff;
            opacity = position > 0
                ? position
                : 1 +
                    position; //1-(position <=0 ? position.abs() : 1 - position);
            alpha = (0xff * opacity).toInt();

            paint.color = new Color((alpha << 24) | color);
            canvas.drawRect(
                new Rect.fromLTWH(0.0, 0.0, size.width, size.height), paint);
          }
        }
      },
      child: child,
    );
  }
}

class ParallaxContainer extends StatelessWidget {
  final Widget child;
  final double position;
  final double translationFactor;
  final double opacityFactor;

  ParallaxContainer(
      {@required this.child,
      @required this.position,
      this.translationFactor: 100.0,
      this.opacityFactor: 1.0})
      : assert(position != null),
        assert(translationFactor != null);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: (1 - position.abs()).clamp(0.0, 1.0) * opacityFactor,
      child: new Transform.translate(
        offset: new Offset(position * translationFactor, 0.0),
        child: child,
      ),
    );
  }
}

class ParallaxImage extends StatelessWidget {
  final Image image;
  final double imageFactor;

  ParallaxImage.asset(String name, {double position, this.imageFactor: 0.3})
      : assert(imageFactor != null),
        image = Image.asset(name,
            fit: BoxFit.cover,
            alignment: FractionalOffset(
              0.5 + position * imageFactor,
              0.5,
            ));

  @override
  Widget build(BuildContext context) {
    return image;
  }
}
