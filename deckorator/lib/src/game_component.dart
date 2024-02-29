import 'dart:typed_data';
import 'package:logging/logging.dart';
import 'geometry.dart';
import 'renderer.dart';
import 'theme.dart';
import 'ui.dart';
import 'assets.dart';
import 'images.dart';
import 'data/data_table.dart';

/// Context when building a component. This has everything you might need to
/// generate a component.
class GameComponentBuildContext {
  final Logger log;
  final UiTools ui;

  /// For manipulating images (masking, resizing etc)
  final ImageTools images;

  final GameDpi dpi;

  final GameTheme theme;

  /// Allows you to generate a component - this is usually used for complex
  /// image manipulation steps such as masking.
  Future<Uint8List> buildAsset(String assetKey) async {
    return await renderer.buildAsset(key: assetKey, ctx: this);
  }

  final double bleed;
  final GameComponentType componentType;
  final GameComponent component;

  GameComponentSize get size => componentType.size;

  GameComponentSize get sizeWithBleed => GameComponentSize(
      componentType.size.width + (bleed * 2),
      componentType.size.height + (bleed * 2));

  String dataString(String key) => data(key).toString();

  T data<T>(String key) {
    if (!component.data.has(key) && !componentType.data.containsKey(key)) {
      throw Exception('Data not found with key $key');
    }

    return component.data.has(key)
        ? component.data.value(key)
        : componentType.data[key];
  }

  GameComponentRenderer get renderer =>
      component.renderer != null ? component.renderer! : componentType.renderer;

  double widthWithBleed(double bleed) => size.x + (bleed * 2);
  double heightWithBleed(double bleed) => size.y + (bleed * 2);

  double percentageOfWidth(num v) => size.x * (v / 100);
  double percentageOfHeight(num v) => size.y * (v / 100);

  GameComponentBuildContext({
    required this.log,
    required this.ui,
    required this.images,
    required this.theme,
    required this.dpi,
    required double bleed,
    required this.componentType,
    required this.component,
  }) : this.bleed = bleed;
}

/// Collection of components of the same type (Monster, Equipment, Class etc)
class GameComponentType {
  final List<GameComponent> components;

  /// Default size for this component type
  final GameComponentSize size;

  /// Data (keys+values) that can be accessed by your GameComponentRenderer
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
  /// Data (keys+values) that can be accessed by your GameComponentRenderer
  /// This will be added to any data in this GameComponentType
  final DataTableRow data;

  /// Override the default renderers for this component
  final GameComponentRenderer? renderer;

  GameComponent({
    required this.data,
    // required this.assets,
    this.renderer,
  });
}
