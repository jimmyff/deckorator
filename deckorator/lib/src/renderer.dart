import 'game.dart';
import 'game_component.dart';

abstract class GameComponentRenderer<dWidget> {
  Future<List<dWidget>> frontBuilder(
      {required GameComponentUiContext ctx, bool showDebug = false});
  List<dWidget> backBuilder(GameComponentUiContext context);
}

class GameDpi {
  final double _point = 1.0;
  final double dpi; // Number of dots per inch
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
