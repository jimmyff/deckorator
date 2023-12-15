import 'dart:typed_data';
import 'game.dart';
import 'game_component.dart';

/// Abstract Component Renderer. You should implement one of
/// these for each of your visually different component types
/// (eg: hero, monster etc)
abstract class GameComponentRenderer<dWidget> {
  Future<Uint8List> buildAsset(
      {required String key, required GameComponentBuildContext ctx});

  Future<List<dWidget>> buildFront(
      {required GameComponentBuildContext ctx, bool showDebug = false});

  List<dWidget> buildBack(GameComponentBuildContext context);
}

/// Holds the current resolution, used when calculating pixels/dots per
/// measurement. Deckorator uses mm for all it's scales.
class GameDpi {
  final double _point = 1.0;
  final double dpi; // dots per inch
  final double _mm;
  final double _cm;

  double pt(double v) => v * _point;
  double mm(double v) => v * _mm;

  double? mmNull(double? v) => v == null ? null : v * _mm;
  double cm(double v) => v * _cm;

  GameDpi({required this.dpi})
      : _mm = dpi / 25.4,
        _cm = dpi / 2.54;
}
