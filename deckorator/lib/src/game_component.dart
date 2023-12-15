import 'dart:typed_data';
import 'package:logging/logging.dart';
import 'geometry.dart';
import 'renderer.dart';
import 'theme.dart';
import 'ui.dart';
import 'assets.dart';
import 'images.dart';

class GameComponentUiContext {
  final Logger log;
  final UiTools ui;
  final ImageTools images;

  final GameDpi dpi;

  final GameTheme theme;

  // final Set<String> assets;

  Future<Uint8List> buildAsset(String assetKey) async {
    return await renderer.buildAsset(key: assetKey, ctx: this);
  }

  final double bleed;

  final GameComponentType componentType;
  final GameComponent component;

  GameComponentSize get size => GameComponentSize(
      (component.size?.width ?? componentType.size.width),
      (component.size?.height ?? componentType.size.height));

  GameComponentSize get sizeWithBleed => GameComponentSize(
      (component.size?.width ?? componentType.size.width) + (bleed * 2),
      (component.size?.height ?? componentType.size.height) + (bleed * 2));

  T data<T>(String key) => component.data.containsKey(key)
      ? component.data[key]!
      : componentType.data[key];

  GameComponentRenderer get renderer =>
      component.renderer != null ? component.renderer! : componentType.renderer;

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
    required this.images,
    required this.theme,
    // required this.assets,
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

/// Collection of components of the same type (Monster, Equipment, Class etc)
class GameComponentType {
  final List<GameComponent> components;

  /// Default size for this component type
  final GameComponentSize size;

  final Map<String, dynamic> data;

  /// Default List of asset files that for this component type
  final Set<String> assets;

  /// Default renderers for this component type
  final GameComponentRenderer renderer;

  GameComponentType({
    required this.data,
    required this.assets,
    required this.components,
    required this.renderer,
    required this.size,
  });
}

// A generic component object that is used by PDF tools
class GameComponent {
  final Map<String, dynamic> data;
  final GameComponentSize? size;

  /// Override the default renderers for this component
  final GameComponentRenderer? renderer;

  // /// List of asset files that are required to be loaded for this component
  // final Set<String> assets;

  GameComponent({
    required this.data,
    // required this.assets,
    this.size,
    this.renderer,
  });
}
