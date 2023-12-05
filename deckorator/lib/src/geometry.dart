class GameComponentPoint {
  const GameComponentPoint(this.x, this.y);

  factory GameComponentPoint.cardBridge() => GameComponentPoint(56.0, 87.0);
  factory GameComponentPoint.cardPoker() => GameComponentPoint(63.0, 88.0);
  factory GameComponentPoint.cardTarot() => GameComponentPoint(70.0, 120.0);

  final double x, y;

  static const GameComponentPoint zero = GameComponentPoint(0.0, 0.0);

  @override
  String toString() => 'GameComponentPoint($x, $y)';

  GameComponentPoint translate(double offsetX, double offsetY) =>
      GameComponentPoint(x + offsetX, y + offsetY);
}
