import 'dart:typed_data';
import 'package:flutter/painting.dart' as painting;
import 'package:deckorator/deckorator.dart';
import 'package:flutter/widgets.dart';

import 'package:widget_mask/widget_mask.dart';

class FlutterTools extends UiTools<Widget, Color, EdgeInsets> {
  get defaultTextSize => 4.0;
  get defaultTextColor => Color.fromRGBO(0, 0, 0, 1.0);
  get defaultFont => 'Faehound';

  Widget text(String text, {Color? color, double? size}) => Text(
        text,
        softWrap: false,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: defaultFont,
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

  Widget imageFromBytes({
    required Uint8List bytes,
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
        child: Image.memory(
          bytes,
          fit: BoxFit.contain,
        ));
  }

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
                // WidgetMask(
                //     // `BlendMode.difference` results in the negative of `dst` where `src`
                //     // is fully white. That is why the text is white.
                //     blendMode: BlendMode.screen,
                //     mask: Image.memory(
                //       snapshot.data!,
                //       fit: BoxFit.fill,
                //     ),
                //     child: Container(
                //       color: colorHex('#908723'),
                //     ),
                //   )

                // ColorFiltered(
                //     colorFilter:
                //         ColorFilter.mode(colorHex('#a6F742'), BlendMode.srcIn),
                //     child: Image.memory(
                //       snapshot.data!,
                //       fit: BoxFit.fill,
                //     ),
                //   )
//
                // ShaderMask(
                //     shaderCallback: (Rect bounds) {
                //       return painting.ColorFilter.mode(
                //           painting.Color(), painting.BlendMode);
                //       // return LinearGradient(
                //       //   colors: <Color>[
                //       //     colorHex('#F6F7D2'),
                //       //     colorHex('#D6D7B2')
                //       //   ],
                //       //   begin: Alignment.topCenter,
                //       //   end: Alignment.bottomCenter,
                //       //   tileMode: TileMode.clamp,
                //       // ).createShader(bounds);
                //     },
                //     blendMode: BlendMode.srcIn,
                //     child: Image.memory(
                //       snapshot.data!,
                //       fit: BoxFit.fill,
                //     ))
                : Container(
                    color: snapshot.hasError
                        ? colorHex('#9A114F')
                        : colorHex('#000000'),
                    child: text(
                        '${snapshot.hasError ? snapshot.error : 'Loading'}',
                        color: colorHex('#ffffff')),
                  )));
  }

  Widget mask({
    required String assetPath,
    required String assetPathMask,
    Color? maskColor,
    Widget? child,
    bool? showDebug,
  }) {
    return Stack(children: [
      FutureBuilder<Uint8List>(
          future: assets.load(assetPathMask, log: log),
          builder: (context, snapshot) => snapshot.hasData
              ? ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      maskColor ?? colorHex('#ffffff'), BlendMode.modulate),
                  child: Image.memory(
                    snapshot.data!,
                    fit: BoxFit.fill,
                  ),
                )
              : Container(
                  color: snapshot.hasError
                      ? colorHex('#9A114F')
                      : colorHex('#000000'),
                  child: text(
                      '${snapshot.hasError ? snapshot.error : 'Loading'}',
                      color: colorHex('#ffffff')),
                )),

      // top layer
      FutureBuilder<Uint8List>(
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
                )),
    ]);
  }

  Widget mask2({
    required String assetPath,
    required String assetPathMask,
    Color? maskColor,
    Widget? child,
    bool? showDebug,
  }) {
    return Stack(children: [
      FutureBuilder<Uint8List>(
          future: assets.load(assetPathMask, log: log),
          builder: (context, snapshot) => snapshot.hasData
              ? WidgetMask(
                  // `BlendMode.difference` results in the negative of `dst` where `src`
                  // is fully white. That is why the text is white.
                  blendMode: BlendMode.modulate,
                  mask: Image.memory(
                    snapshot.data!,
                    fit: BoxFit.fill,
                  ),
                  child: Container(
                    color: maskColor,
                    child: child,
                  ))
              : Container(
                  color: snapshot.hasError
                      ? colorHex('#9A114F')
                      : colorHex('#000000'),
                  child: text(
                      '${snapshot.hasError ? snapshot.error : 'Loading'}',
                      color: colorHex('#ffffff')),
                )),
//       Container(
//           decoration: BoxDecoration(
//               border: !(showDebug ?? debugEnabled)
//                   ? null
//                   : Border.all(
//                       color: Color.fromRGBO(229, 255, 0, 1),
//                       style: BorderStyle.solid,
//                       strokeAlign: BorderSide.strokeAlignInside)),
//           child: FutureBuilder<Uint8List>(
//               future: assets.load(assetPath, log: log),
//               builder: (context, snapshot) => snapshot.hasData
//                   ? Image.memory(
//                       snapshot.data!,
//                       fit: BoxFit.fill,
//                     )
//                   // WidgetMask(
//                   //     // `BlendMode.difference` results in the negative of `dst` where `src`
//                   //     // is fully white. That is why the text is white.
//                   //     blendMode: BlendMode.screen,
//                   //     mask:
//                   //     Image.memory(
//                   //       snapshot.data!,
//                   //       fit: BoxFit.fill,
//                   //     ),
//                   //     child: Container(
//                   //       color: colorHex('#908723'),
//                   //     ),
//                   //   )

//                   // ColorFiltered(
//                   //     colorFilter:
//                   //         ColorFilter.mode(colorHex('#a6F742'), BlendMode.srcIn),
//                   //     child: Image.memory(
//                   //       snapshot.data!,
//                   //       fit: BoxFit.fill,
//                   //     ),
//                   //   )
// //
//                   // ShaderMask(
//                   //     shaderCallback: (Rect bounds) {
//                   //       return painting.ColorFilter.mode(
//                   //           painting.Color(), painting.BlendMode);
//                   //       // return LinearGradient(
//                   //       //   colors: <Color>[
//                   //       //     colorHex('#F6F7D2'),
//                   //       //     colorHex('#D6D7B2')
//                   //       //   ],
//                   //       //   begin: Alignment.topCenter,
//                   //       //   end: Alignment.bottomCenter,
//                   //       //   tileMode: TileMode.clamp,
//                   //       // ).createShader(bounds);
//                   //     },
//                   //     blendMode: BlendMode.srcIn,
//                   //     child: Image.memory(
//                   //       snapshot.data!,
//                   //       fit: BoxFit.fill,
//                   //     ))
//                   : Container(
//                       color: snapshot.hasError
//                           ? colorHex('#9A114F')
//                           : colorHex('#000000'),
//                       child: text(
//                           '${snapshot.hasError ? snapshot.error : 'Loading'}',
//                           color: colorHex('#ffffff')),
//                     )))
    ]);
  }

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

// // Applies a BlendMode to its child.
// class BlendMask extends SingleChildRenderObjectWidget {
//   final BlendMode _blendMode;
//   final double _opacity;

//   BlendMask(
//       {required BlendMode blendMode,
//       double opacity = 1.0,
//       Key? key,
//       Widget? child})
//       : _blendMode = blendMode,
//         _opacity = opacity,
//         super(key: key, child: child);

//   @override
//   RenderObject createRenderObject(context) {
//     return RenderBlendMask(_blendMode, _opacity);
//   }

//   @override
//   void updateRenderObject(BuildContext context, RenderBlendMask renderObject) {
//     renderObject._blendMode = _blendMode;
//     renderObject._opacity = _opacity;
//   }
// }

// class RenderBlendMask extends RenderProxyBox {
//   BlendMode _blendMode;
//   double _opacity;

//   RenderBlendMask(BlendMode blendMode, double opacity)
//       : _blendMode = blendMode,
//         _opacity = opacity;

//   @override
//   void paint(context, offset) {
//     // Create a new layer and specify the blend mode and opacity to composite it with:
//     context.canvas.saveLayer(
//         offset & size,
//         Paint()
//           ..blendMode = _blendMode
//           ..color = Color.fromARGB((_opacity * 255).round(), 255, 255, 255));

//     super.paint(context, offset);

//     // Composite the layer back into the canvas using the blendmode:
//     context.canvas.restore();
//   }
// }
