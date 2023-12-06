import 'dart:typed_data';
import 'package:deckorator/deckorator.dart';
import 'package:flutter/widgets.dart';

class FlutterTools extends UiTools<Widget, Color, EdgeInsets> {
  get defaultTextSize => 5.0;
  get defaultTextColor => Color.fromRGBO(0, 0, 0, 1.0);

  Widget text(String text, {Color? color, double? size}) => Text(
        text,
        softWrap: false,
        style: TextStyle(
            fontSize: dpi.mm(size ?? defaultTextSize),
            color: color ?? defaultTextColor,
            height: 1.0,
            overflow: TextOverflow.visible),
      );
  EdgeInsets edgeInset({
    double left = 0.0,
    double right = 0.0,
    double top = 0.0,
    double bottom = 0.0,
  }) =>
      EdgeInsets.only(
          left: dpi.mm(left),
          right: dpi.mm(right),
          top: dpi.mm(top),
          bottom: dpi.mm(bottom));

  Widget stack({
    required List<dynamic> children,
  }) =>
      Stack(
        children: List<Widget>.from(children),
      );

  Widget image({
    required String assetPath,
    bool? showDebug,
  }) {
    return Container(
        decoration: BoxDecoration(
            border: !(showDebug ?? debugEnabled)
                ? null
                : Border.all(
                    color: Color.fromRGBO(229, 255, 0, 1),
                    style: BorderStyle.solid,
                    strokeAlign: BorderSide.strokeAlignInside)),
        child: FutureBuilder<Uint8List>(
            future: assets.load(assetPath, log: log),
            builder: (context, snapshot) => snapshot.hasData
                ? Image.memory(
                    snapshot.data!,
                    fit: BoxFit.fill,
                  )
                : Container(
                    color: snapshot.hasError
                        ? colorHex('#9A114F')
                        : colorHex('#000000'),
                    child: text(
                        '${snapshot.hasError ? snapshot.error : 'Loading'}',
                        color: colorHex('#ffffff')),
                  )));
  }

  Widget positioned({
    double? top,
    double? right,
    double? bottom,
    double? left,
    double? height,
    double? width,
    required Widget child,
    bool? showDebug,
  }) =>
      Positioned(
          top: dpi.mmNull(top),
          left: dpi.mmNull(left),
          right: dpi.mmNull(right),
          bottom: dpi.mmNull(bottom),
          height: dpi.mmNull(height),
          width: dpi.mmNull(width),
          child: Container(
              decoration: BoxDecoration(
                  border: !(showDebug ?? debugEnabled)
                      ? null
                      : Border.all(
                          color: Color.fromRGBO(0, 255, 0, 1.0),
                          style: BorderStyle.solid,
                          strokeAlign: BorderSide.strokeAlignInside)),
              child: child));

  Widget container({
    bool? showDebug,
    GameComponentPoint? size,
    Widget? child,
    Color? color,
    EdgeInsets? padding,
    EdgeInsets? margin,
  }) =>
      Container(
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
            color: color,
            border: !(showDebug ?? debugEnabled)
                ? null
                : Border.all(
                    color: Color.fromRGBO(0, 0, 255, 1.0),
                    strokeAlign: BorderSide.strokeAlignInside)),

        width: dpi.mmNull(size?.x),
        height: dpi.mmNull(size?.y),
        // constraints: BoxConstraints.tightFor(
        //     width: constraints.minWidth, height: constraints.minHeight),
        child: child,
      );

  Color colorHex(String hex) => HexColor.fromHex(hex);

  List<Widget> componentDebugOverlay(GameComponentUiContext ctx) {
    return [
      // Show working area
      ctx.ui.positioned(
          left: ctx.bleed,
          right: ctx.bleed,
          top: ctx.bleed,
          bottom: ctx.bleed,
          showDebug: false,
          child: ctx.ui.container()),

      // Show guide
      if (ctx.component.data['guide'] is double)
        ctx.ui.positioned(
            left: ctx.bleed + ctx.component.data['guide'],
            right: ctx.bleed + ctx.component.data['guide'],
            top: ctx.bleed + ctx.component.data['guide'],
            bottom: ctx.bleed + ctx.component.data['guide'],
            showDebug: false,
            child: ctx.ui.container()),

      // Grey out bleed
      ctx.ui.positioned(
          showDebug: false,
          left: 0,
          right: 0,
          top: 0,
          height: ctx.bleed,
          child: ctx.ui
              .container(showDebug: false, color: ctx.ui.colorHex('#333333'))),
      ctx.ui.positioned(
          showDebug: false,
          left: 0,
          right: 0,
          bottom: 0,
          height: ctx.bleed,
          child: ctx.ui
              .container(showDebug: false, color: ctx.ui.colorHex('#333333'))),
      ctx.ui.positioned(
          showDebug: false,
          left: 0,
          width: ctx.bleed,
          top: ctx.bleed,
          bottom: ctx.bleed,
          child: ctx.ui
              .container(showDebug: false, color: ctx.ui.colorHex('#333333'))),
      ctx.ui.positioned(
          showDebug: false,
          right: 0,
          width: ctx.bleed,
          top: ctx.bleed,
          bottom: ctx.bleed,
          child: ctx.ui
              .container(showDebug: false, color: ctx.ui.colorHex('#333333')))
    ];
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
