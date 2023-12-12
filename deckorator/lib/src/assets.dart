import 'dart:typed_data';

import 'package:logging/logging.dart';

/// Abstract platform loader, also handles caching of loaded assets
abstract class AssetLoader {
  static const poolSize = 30;

  final Map<String, Uint8List> assetPool = {};
  final List<String> assetPoolKeys = [];
  String basePath = '';

  Future<Uint8List> readFromPath(String path);

  Future<Uint8List> load(String path, {Logger? log}) async {
    path = basePath + path;
    // already have it cached
    if (assetPool.containsKey(path)) {
      // move key to top of asset pool
      assetPoolKeys
        ..remove(path)
        ..insert(0, path);
      log?.fine('Asset loaded from pool. Pool size: ${assetPool.length}');
      return assetPool[path]!;
    }

    // load it
    final data = await readFromPath(path);
    assetPool[path] = data;
    assetPoolKeys.insert(0, path);

    // Trim asset pool down to size
    while (assetPoolKeys.length > AssetLoader.poolSize) {
      final removed = assetPoolKeys.removeLast();
      assetPool.remove(removed);
    }
    log?.fine('Asset added to pool, size: ${assetPool.length}: $path');
    // log?.fine('Asset pool: ${assetPool.keys}');
    return data;
  }
}
