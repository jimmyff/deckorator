class GameTheme {
  final Map<String, String> colors;

  String colorHex(String key) {
    if (!colors.containsKey(key))
      throw Exception('Color not found with key: $key');
    return colors[key]!;
  }

  GameTheme({required this.colors});
}
