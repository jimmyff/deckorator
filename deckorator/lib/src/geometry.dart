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

class GameComponentOffset {
  const GameComponentOffset({
    this.top = 0.0,
    this.left = 0.0,
    this.bottom = 0.0,
    this.right = 0.0,
  });

  final double top, left, bottom, right;

  factory GameComponentOffset.all(double v) =>
      GameComponentOffset(top: v, right: v, bottom: v, left: v);

  @override
  String toString() =>
      'GameComponentOffset(top:$top, right:$right, bottom:$bottom, left:$left)';

  GameComponentOffset operator +(GameComponentOffset o) => GameComponentOffset(
      top: top + o.top,
      right: right + o.right,
      bottom: bottom + o.bottom,
      left: left + o.left);
}
