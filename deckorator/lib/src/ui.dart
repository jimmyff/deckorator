import 'dart:typed_data';
import 'package:logging/logging.dart';

import 'game.dart';
import 'game_component.dart';
import 'geometry.dart';
import 'renderer.dart';
import 'assets.dart';

/// Abstract standard interface for a Platform UI library.
/// Currently used by FlutterTools and PdfTools.
abstract class UiTools<dWidget, dColor, dEdgeInsets> {
  Logger? log;
  bool debugEnabled = false;
  GameDpi dpi = GameDpi(dpi: 70);
  late AssetLoader assets;

  dWidget text(String text,
      {dColor? color,
      double? size,
      bool wrap = false,
      GameComponentAlignment alignment = GameComponentAlignment.middle});
  dWidget container({
    bool? showDebug,
    GameComponentSize? size,
    double? height,
    double? width,
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

  dWidget row({
    required List<dWidget> children,
    List<dWidget>? dividers,
    GameComponentSize? size,
    bool? showDebug,
  });
  dWidget column({
    required List<dWidget> children,
    GameComponentSize? size,
    bool? showDebug,
  });

  dWidget flexChild({
    required dWidget child,
    int flex = 1,
    bool? showDebug,
  });
  dWidget rotate({
    required dWidget child,
    int rotations = 0,
    bool? showDebug,
  });

  dWidget image({
    required String assetPath,
    bool? showDebug,
  });

  dWidget imageFromBytes({
    required GameComponentSize size,
    required Uint8List bytes,
    bool? showDebug,
  });

  dColor colorHex(String hex);
  dEdgeInsets edgeInset({
    double left = 0.0,
    double right = 0.0,
    double top = 0.0,
    double bottom = 0.0,
  });

  List<dWidget> componentDebugOverlay(GameComponentBuildContext ctx);
}
