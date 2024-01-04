class GameTheme {
  /// Named colors
  final Map<String, ThemeColor> colors;

  // String colorHex(String key) {
  //   if (!colors.containsKey(key))
  //     throw Exception('Color not found with key: $key');
  //   return colors[key]!;
  // }

  GameTheme({required this.colors});
}

class ThemeColor {
  /// CMYK color, used for print output.
  /// 0-100 values for cyan, magenta, yellow, key (black)
  final (int, int, int, int) _cmyk;

  /// RGB color, used for digital output
  /// 0-255 values for red, green, blue
  final (int, int, int) _rgb;

  ThemeColor({
    required (int, int, int, int)? cmyk,
    required (int, int, int)? rgb,
  })  : _cmyk = cmyk!,
        _rgb = rgb!;
}
