import 'dart:typed_data';
import 'package:logging/logging.dart';
import 'geometry.dart';
import 'renderer.dart';
import 'game.dart';
import 'theme.dart';

class GameComponentUiContext {
  final Logger log;
  final UiTools ui;

  final GameDpi dpi;

  final GameTheme theme;

  final Set<String> assets;

  final double bleed;

  final GameComponentType componentType;
  final GameComponent component;

  GameComponentPoint get size => GameComponentPoint(
      (component.size?.x ?? componentType.size.x),
      (component.size?.y ?? componentType.size.y));

  GameComponentPoint get sizeWithBleed => GameComponentPoint(
      (component.size?.x ?? componentType.size.x) + (bleed * 2),
      (component.size?.y ?? componentType.size.y) + (bleed * 2));

  // Scaling
  // GameComponentPoint get size =>
  //     GameComponentPoint(sizeUnscaled.x * scale, sizeUnscaled.y * scale);
  // double get bleedScaled => bleed * scale;

  // Uint8List assetData(String key) {
  //   if (!assets.containsKey(key))
  //     throw Exception(
  //         'Asset not found with key: $key. Did you declare it in the GameComponent asset array?');
  //   return assets[key]!;
  // }

  // double widthPercent(num v) => percentageOfWidth(v) * dpi;
  // double heightPercent(num v) => percentageOfHeight(v) * dpi;

  double widthWithBleed(double bleed) => size.x + (bleed * 2);
  double heightWithBleed(double bleed) => size.y + (bleed * 2);

  double percentageOfWidth(num v) => size.x * (v / 100);
  double percentageOfHeight(num v) => size.y * (v / 100);

/*

  width = 100
  bleed = 5
  total width = 110

  space = 220 / (110)

*/
  GameComponentUiContext({
    required this.log,
    required this.ui,
    required this.theme,
    required this.assets,
    // required this.resolution,
    // required this.pdfContext,
    // required this.constraints,
    required this.dpi,
    required double bleed,
    required this.componentType,
    required this.component,
  }) : this.bleed = bleed
  // ,
  //       scale = constraints.maxWidth /
  //           ((component.size?.x ?? componentType.size.x) + (bleed * 2)
  // )
  {
    // print('scale: $scale');
    // print('maxWidth: ${constraints.maxWidth}');
    // print('constraints: ${constraints}');

    // this.resolution.setScale(scale);
  }
  // final pw;
}

// typedef pw.Widget WidgetBuildFunction(GameComponentUiContext context);

abstract class UiTools<dWidget, dColor, dEdgeInsets> {
  bool debugEnabled = false;
  GameDpi dpi = GameDpi(dpi: 70);

  dWidget text(String text, {dColor? color, double? size});
  dWidget container({
    bool? showDebug,
    GameComponentPoint? size,
    dWidget? child,
    dColor? color,
    dEdgeInsets? padding,
    dEdgeInsets? margin,
  });
  dWidget stack({
    required List<dWidget> children,
  });
  dWidget positioned({
    double? top,
    double? right,
    double? bottom,
    double? left,
    double? height,
    double? width,
    required dWidget child,
    bool? showDebug,
  });
  dColor colorHex(String hex);
  dEdgeInsets edgeInset({
    double left = 0.0,
    double right = 0.0,
    double top = 0.0,
    double bottom = 0.0,
  });

  List<dWidget> componentDebugOverlay(GameComponentUiContext ctx);
}

/// Collection of components of the same type (Monster, Equipment, Class etc)
class GameComponentType {
  final List<GameComponent> components;

  /// Default size for this component type
  final GameComponentPoint size;

  /// Default List of asset files that for this component type
  final Set<String> assets;

  /// Default renderers for this component type
  final GameComponentRenderer renderer;

  GameComponentType({
    required this.assets,
    required this.components,
    required this.renderer,
    required this.size,
  });
}

// A generic component object that is used by PDF tools
class GameComponent {
  final Map<String, dynamic> data;
  final GameComponentPoint? size;

  /// Override the default renderers for this component
  final GameComponentRenderer? renderer;

  /// List of asset files that are required to be loaded for this component
  final Set<String> assets;

  GameComponent({
    required this.data,
    required this.assets,
    this.size,
    this.renderer,
  });
}
