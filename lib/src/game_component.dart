import 'package:pdf/widgets.dart';

typedef Widget WidgetBuildFunction(Context context, double bleed);

// A generic component object that is used by PDF tools
class GameComponent {
  final double width;
  final double height;
  final WidgetBuildFunction buildFront;
  final WidgetBuildFunction buildBack;

  double widthWithBleed(double bleed) => width + (bleed * 2);
  double heightWithBleed(double bleed) => height + (bleed * 2);

  GameComponent(this.width, this.height, this.buildFront, this.buildBack);
}
