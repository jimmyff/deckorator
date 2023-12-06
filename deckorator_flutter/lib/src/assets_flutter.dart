import 'dart:typed_data';
import 'package:deckorator/deckorator.dart';
import 'package:flutter/services.dart' show rootBundle;

/// Flutter asset loader
class FlutterAssetLoader extends AssetLoader {
  Future<Uint8List> readFromPath(String path) async {
    final data = await rootBundle.load(path);
    final buffer = data.buffer;
    return buffer.asUint8List();
  }
}
