import 'dart:typed_data';

import 'game.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
// import 'package:pdf

class GameComponentUiContext {
  final GameTheme theme;
  final pw.Context pdfContext;
  final pw.BoxConstraints constraints;
  final Map<String, Uint8List> assets;

  final double bleedUnscaled;

  double get bleed => bleedUnscaled * scale;

  final GameComponent component;
  final double scale;

  PdfPoint get size =>
      PdfPoint(component.size.x * scale, component.size.y * scale);

  Uint8List assetData(String key) {
    if (!assets.containsKey(key))
      throw Exception(
          'Asset not found with key: $key. Did you declare it in the GameComponent asset array?');
    return assets[key]!;
  }

  double widthPercent(num v) => size.x * (v / 100);
  double heightPercent(num v) => size.y * (v / 100);

/*

  width = 100
  bleed = 5
  total width = 110

  space = 220 / (110)

*/
  GameComponentUiContext({
    required this.theme,
    required this.assets,
    required this.pdfContext,
    required this.constraints,
    required double bleed,
    required this.component,
  })  : this.bleedUnscaled = bleed,
        scale = constraints.maxWidth / (component.size.x + (bleed * 2)) {
    print('scale: $scale');
    print('maxWidth: ${constraints.maxWidth}');
    print('component.size: ${component.size}');
  }
  // final pw;
}

typedef pw.Widget WidgetBuildFunction(GameComponentUiContext context);

// A generic component object that is used by PDF tools
class GameComponent {
  final PdfPoint size;
  final WidgetBuildFunction frontBuilder;
  final WidgetBuildFunction backBuilder;

  /// List of asset files that are required to be loaded for this component
  final List<String> assets;

  double widthWithBleed(double bleed) => size.x + (bleed * 2);
  double heightWithBleed(double bleed) => size.y + (bleed * 2);

  GameComponent({
    required this.assets,
    required this.size,
    required this.frontBuilder,
    required this.backBuilder,
  });
}
