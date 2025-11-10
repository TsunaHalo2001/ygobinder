part of 'main.dart';

class FileHelper {
  String localPath = '';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    localPath = directory.path;
    return directory.path;
  }

  // Obtener la referencia
  Future<File> get _localCache async {
    final path = await _localPath;
    return File('$path/ygo_api_cache.json');
  }

  Future<File> get _localInventory async {
    final path = await _localPath;
    return File('$path/ygo_inventory.json');
  }

  Future<File> _localImage(int id) async {
    final path = await _localPath;
    return File('$path/images/cards_cropped/$id.jpg');
  }

  Future<File> writeDataCache(String data) async {
    final file = await _localCache;
    return file.writeAsString(data);
  }

  Future<File> writeDataInventory(String data) async {
    final file = await _localInventory;
    return file.writeAsString(data);
  }

  Future<File> writeImage(int id, Uint8List data) async {
    final file = await _localImage(id);
    return file.writeAsBytes(data);
  }

  Future<String?> readDataCache() async {
    try {
      final file = await _localCache;

      if (!await file.exists()) return null;

      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      return null;
    }
  }

  Future<String?> readDataInventory() async {
    try {
      final file = await _localInventory;

      if (!await file.exists()) return null;

      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      return null;
    }
  }

  Future<Uint8List?> readImage(int id) async {
    try {
      final file = await _localImage(id);

      if (!await file.exists()) return null;

      final contents = await file.readAsBytes();
      return contents;
    } catch (e) {
      return null;
    }
  }
}