import 'dart:io';
import 'package:image/image.dart';

/// Resizes a a list of PNG images.
/// You must specify either a width and height for the files,
/// or an aspect ratio to resize by.
Future resizePngs(
    {int width,
    int height,
    double ratio,
    List<File> files,
    Directory output}) async {
  List<Future> futures = [];
  for (final file in files)
    futures.add(resizePng(
        width: width,
        height: height,
        ratio: ratio,
        file: file,
        output: output));

  await Future.wait(futures);
}

/// Resizes a single PNG image.
/// You must specify either a width and height for the files,
/// or an aspect ratio to resize by.
Future resizePng(
    {int width, int height, double ratio, File file, Directory output}) async {
  Image image = decodeImage(file.readAsBytesSync());

  Image newImg;
  if (ratio != null) {
    newImg = copyResize(image,
        width: (image.width * ratio).round(),
        height: (image.height * ratio).round());
  } else {
    newImg = copyResize(image, width: width, height: height);
  }

  final encoded = encodePng(newImg, level: 6);

  await File('${output.path}/${file.path.split('/').last}')
    ..writeAsBytes(encoded);
}
