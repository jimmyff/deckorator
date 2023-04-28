import 'game_component.dart';
import 'package:pdf/pdf.dart';

// A generic game
class Game {
  final Map<String, List<GameComponent>> components;

  List<GameComponent> get allComponents =>
      components.values.fold(<GameComponent>[], (all, sub) => all..addAll(sub));

  final GameTheme theme;

  Game({required this.theme, required this.components});
}

class GameTheme {
  final Map<String, PdfColor> colors;

  PdfColor color(String key) {
    if (!colors.containsKey(key))
      throw Exception('Color not found with key: $key');
    return colors[key]!;
  }

  GameTheme({required this.colors});
}

enum cardTypes { bridge, poker, tarot }

final cardSizes = const <cardTypes, PdfPoint>{
  cardTypes.bridge: PdfPoint(56.0, 87.0),
  cardTypes.poker: PdfPoint(63.0, 88.0),
  cardTypes.tarot: PdfPoint(70.0, 120.0),
};
