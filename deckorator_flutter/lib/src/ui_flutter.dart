import 'dart:typed_data';
import 'package:deckorator/deckorator.dart';
import 'package:flutter/widgets.dart';

/// UI tooling for generating Flutter widgets.
class FlutterTools extends UiTools<Widget, Color, EdgeInsets> {
  get defaultTextSize => 3.0;
  get defaultTextColor => Color.fromRGBO(0, 0, 0, 1.0);
  get defaultFont => 'Faehound';

  @override
  Widget text(String text,
          {Color? color,
          double? size,
          bool wrap = false,
          GameComponentAlignment alignment = GameComponentAlignment.middle}) =>
      Text(
        text,
        softWrap: wrap,
        textAlign: alignment == GameComponentAlignment.middle
            ? TextAlign.center
            : (alignment == GameComponentAlignment.start
                ? TextAlign.left
                : TextAlign.right),
        style: TextStyle(
          fontFamily: defaultFont,
          fontSize: dpi.mm(size ?? defaultTextSize),
          color: color ?? defaultTextColor,
          height: wrap ? 1.5 : 1.0,
          overflow: TextOverflow.visible,
        ),
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

  @override
  Widget stack({
    required List<dynamic> children,
  }) =>
      Stack(
        children: List<Widget>.from(children),
      );

  @override
  Widget imageFromBytes({
    required GameComponentSize size,
    required Uint8List bytes,
    bool? showDebug,
  }) {
    return Container(
        width: size.x,
        height: size.y,
        decoration: BoxDecoration(
            border: !(showDebug ?? debugEnabled)
                ? null
                : Border.all(
                    color: Color.fromRGBO(229, 255, 0, 1),
                    style: BorderStyle.solid,
                    strokeAlign: BorderSide.strokeAlignInside)),
        child: Image.memory(
          bytes,
          fit: BoxFit.fill,
        ));
  }

  @override
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

  @override
  Widget positioned({
    GameComponentOffset? offset,
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
          top: dpi.mmNull(offset?.top ?? top),
          left: dpi.mmNull(offset?.left ?? left),
          right: dpi.mmNull(offset?.right ?? right),
          bottom: dpi.mmNull(offset?.bottom ?? bottom),
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
    GameComponentSize? size,
    double? height,
    double? width,
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

        width: dpi.mmNull(width ?? size?.width),
        height: dpi.mmNull(height ?? size?.height),
        // constraints: BoxConstraints.tightFor(
        //     width: constraints.minWidth, height: constraints.minHeight),
        child: child,
      );

  @override
  Color colorHex(String hex) => HexColor.fromHex(hex);

  @override
  List<Widget> componentDebugOverlay(GameComponentBuildContext ctx) {
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

  @override
  Widget flexChild({required Widget child, int flex = 1, bool? showDebug}) =>
      Flexible(
        flex: flex,
        child: Center(child: child),
      );

  @override
  Widget row(
      {List<dynamic>? dividers,
      required List<dynamic> children,
      bool? showDebug,
      GameComponentSize? size}) {
    final childrenWithSeperators = [];

    for (var i = 0, l = children.length; i < l; i++) {
      childrenWithSeperators.add(children[i]);
      if (i < children.length - 1) {
        childrenWithSeperators.add((dividers ?? []).contains(i)
            ? dividers![i]
            : container(
                width: 2,
              ));
      }
    }
    return container(
      size: size,
      child: Row(

          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: List<Widget>.from(childrenWithSeperators)),
    );
  }

  @override
  Widget column(
          {required List<dynamic> children,
          bool? showDebug,
          GameComponentSize? size}) =>
      container(
        size: size,
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: List<Widget>.from(children)),
      );

  @override
  Widget rotate({required Widget child, int rotations = 0, bool? showDebug}) =>
      RotatedBox(
        quarterTurns: rotations,
        child: child,
      );
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
