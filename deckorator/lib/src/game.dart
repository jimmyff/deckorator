import 'package:logging/logging.dart';
import 'game_component.dart';
import 'theme.dart';
import 'renderer.dart';
import 'ui.dart';
import 'assets.dart';

// A generic game
class Game {
  final Map<String, GameComponentType> components;

  List<GameComponent> get allComponents => components.values
      .fold(<GameComponent>[], (all, type) => all..addAll(type.components));

  final GameTheme theme;

  /// Assets that will be provided to every component
  final Set assetsCore;

  Game({
    // required this.resolution,
    required this.theme,
    required this.components,
    required this.assetsCore,
    // required this.renderers,
  });

  renderComponentFront({
    required Logger log,
    required UiTools ui,
    required AssetLoader assets,
    required GameComponent component,
    bool showDebug = false,
    double bleed = 0.0,
    double dpi = 70,
    // required GameComponentBoxConstraints displayConstraints,
  }) {
    final componentType =
        components.values.firstWhere((ct) => ct.components.contains(component));

    final assetsPaths = <String>{
      ...assetsCore,
      ...componentType.assets,
      ...component.assets
    };

    final context = GameComponentUiContext(
      log: log,
      ui: ui
        ..assets = assets
        ..debugEnabled = showDebug
        ..dpi = GameDpi(dpi: dpi)
        ..log = log,

      theme: theme,
      // resolution: resolution,
      assets: assetsPaths,
      // constraints: displayConstraints,
      dpi: GameDpi(dpi: dpi),
      bleed: bleed,
      componentType: componentType,
      component: component,
    );

    return ui.container(
        size: context.sizeWithBleed,
        child: ui.stack(
            children: (component.renderer ?? componentType.renderer)
                .frontBuilder(ctx: context, showDebug: true)
              ..addAll(showDebug ? ui.componentDebugOverlay(context) : [])));
  }
}
