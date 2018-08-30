

import 'package:flutter/widgets.dart';



class ParallaxContainer extends StatelessWidget{

  final Widget child;
  final double position;
  final double translationFactor;
  final double opacityFactor;

  ParallaxContainer({
    this.child,
    this.position ,
    this.translationFactor : 100.0,
    this.opacityFactor : 1.0
}) : assert(position != null ), assert(translationFactor!=null);


  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: (1-position.abs()).clamp(0.0, 1.0) * opacityFactor,
      child: new Transform.translate(offset: new Offset(position*translationFactor, 0.0),child: child,),

    );

  }

}

class ParallaxImage extends StatelessWidget{

  final Image image;
  final double imageFactor;



  ParallaxImage.asset(String name,{
    double position,
    this.imageFactor:0.3
}) : assert(imageFactor!=null), image = Image.asset(
      name,
      fit: BoxFit.cover,
      alignment: FractionalOffset(
        0.5  + position * imageFactor,
        0.5,
      ));

  @override
  Widget build(BuildContext context) {
    return image;

  }
}
