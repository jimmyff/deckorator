import 'game_component.dart';
import 'package:pdf/pdf.dart';

// A generic game
class Game {
  final Map<String, List<GameComponent>> components;

  Game(this.components);
}

enum cardTypes { bridge, poker, tarot }

final cardSizes = const <cardTypes, PdfPoint>{
  cardTypes.bridge: PdfPoint(56.0, 87.0),
  cardTypes.poker: PdfPoint(63.0, 88.0),
  cardTypes.tarot: PdfPoint(70.0, 120.0),
};
