import 'dart:typed_data';
import 'package:logging/logging.dart';

import 'game.dart';
import 'game_component.dart';
import 'geometry.dart';
import 'renderer.dart';
import 'assets.dart';

abstract class UiTools<dWidget, dColor, dEdgeInsets> {
  Logger? log;
  bool debugEnabled = false;
  GameDpi dpi = GameDpi(dpi: 70);
  late AssetLoader assets;

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
    GameComponentOffset? offset,
    double? top,
    double? right,
    double? bottom,
    double? left,
    double? height,
    double? width,
    required dWidget child,
    bool? showDebug,
  });

  dWidget image({
    required String assetPath,
    bool? showDebug,
  });

  dWidget imageFromBytes({
    required Uint8List bytes,
    bool? showDebug,
  });

  dWidget mask({
    required String assetPath,
    required String assetPathMask,
    dColor? maskColor,
    dWidget? child,
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
