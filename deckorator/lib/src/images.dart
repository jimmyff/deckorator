import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart';
import 'package:logging/logging.dart';
import 'renderer.dart';

class ImageTools {
  GameDpi dpi = GameDpi(dpi: 70);

  /// Creates a mask
  Image mask({
    Image? image,
    String? hexColor,
    required Image mask,
    double offsetX = 0.0,
    double offsetY = 0.0,
  }) {
    final offsetXint = dpi.mm(offsetX).round();
    final offsetYint = dpi.mm(offsetY).round();

    final comp = Image(width: mask.width, height: mask.height, numChannels: 4);
    final color = hexColor == null ? null : colorFromHex(hexColor);

    for (var y = 0, yl = mask.height; y < yl; y++) {
      for (var x = 0, xl = mask.width; x < xl; x++) {
        final imgX = x - offsetXint;
        final imgY = y - offsetYint;
        final maskPixel = mask.getPixel(x, y);
        final lum = getLuminanceRgb(maskPixel.r, maskPixel.g, maskPixel.b);

        if (color != null) {
          comp.setPixelRgba(
              x, y, color.r * 255, color.g * 255, color.b * 255, lum);
        }
        if (imgX > 0 &&
            imgY > 0 &&
            image != null &&
            image.width > imgX &&
            image.height > imgY) {
          final imgPixel = image.getPixel(imgX, imgY);
          // final imgLum = getLuminanceRgb(imgPixel.r, imgPixel.g, imgPixel.b);
          comp.setPixelRgba(
              x, y, imgPixel.r, imgPixel.g, imgPixel.b, lum * -imgPixel.a);
        }
      }
    }
    return comp;
  }

  /// Mask Fill - fills the white area with a color, preserves the other parts
  Image maskFill({
    required String hexColor,
    required Image mask,
  }) {
    final comp = Image(width: mask.width, height: mask.height, numChannels: 4);
    final color = colorFromHex(hexColor);

    // Apply the colour
    for (var y = 0, yl = mask.height; y < yl; y++) {
      for (var x = 0, xl = mask.width; x < xl; x++) {
        final maskPixel = mask.getPixel(x, y);
        final lum = getLuminanceRgb(maskPixel.r, maskPixel.g, maskPixel.b);

        comp.setPixelRgba(
            x, y, color.r * 255, color.g * 255, color.b * 255, lum);
      }
    }

    return compositeImage(comp, mask, blend: BlendMode.multiply);
  }

  /// Creates a mask
  Image resize({
    required Image image,
    double? width = null,
    double? height = null,
    Logger? log,
  }) {
    final widthInt = dpi.mmNull(width)?.round();
    final heightInt = dpi.mmNull(height)?.round();
    log?.info(
        'Resizing image (${image.width}x${image.height}) to $width x $height');
    return copyResize(image,
        width: widthInt, height: heightInt, interpolation: Interpolation.cubic);
  }

  /// Decodes bytes to image
  decode({required Uint8List bytes}) => decodePng(bytes);

  /// Encodes png
  encode({required Image image}) => encodePng(
        image, level: 0, // Disable compression
      );
  // Image.fromBytes(width: width, height: height, bytes: bytes.buffer);

  Color colorFromHex(String color) {
    if (color.startsWith('#')) {
      color = color.substring(1);
    }
    assert(color.length == 3 || color.length == 6);
    double red;
    double green;
    double blue;
    if (color.length == 3) {
      red = int.parse(color.substring(0, 1) * 2, radix: 16) / 255;
      green = int.parse(color.substring(1, 2) * 2, radix: 16) / 255;
      blue = int.parse(color.substring(2, 3) * 2, radix: 16) / 255;
      return ColorFloat16.rgb(red, green, blue);
    }
    red = int.parse(color.substring(0, 2), radix: 16) / 255;
    green = int.parse(color.substring(2, 4), radix: 16) / 255;
    blue = int.parse(color.substring(4, 6), radix: 16) / 255;
    print('$red, $green, $blue');
    return ColorFloat16.rgb(red, green, blue);
  }
}

// /// Resizes a a list of PNG images.
// /// You must specify either a width and height for the files,
// /// or an aspect ratio to resize by.
// Future resizePngs(
//     {required int width,
//     required int height,
//     required double ratio,
//     required List<File> files,
//     required Directory output}) async {
//   List<Future> futures = [];
//   for (final file in files)
//     futures.add(resizePng(
//         width: width,
//         height: height,
//         ratio: ratio,
//         file: file,
//         output: output));

//   await Future.wait(futures);
// }

// /// Resizes a single PNG image.
// /// You must specify either a width and height for the files,
// /// or an aspect ratio to resize by.
// Future resizePng(
//     {required int width,
//     required int height,
//     required double ratio,
//     required File file,
//     required Directory output}) async {
//   Image image = decodeImage(file.readAsBytesSync())!;

//   Image newImg;
//   if (ratio != null) {
//     newImg = copyResize(image,
//         width: (image.width * ratio).round(),
//         height: (image.height * ratio).round());
//   } else {
//     newImg = copyResize(image, width: width, height: height);
//   }

//   final encoded = encodePng(newImg, level: 6);

//   await File('${output.path}/${file.path.split('/').last}')
//     ..writeAsBytes(encoded);
// }
