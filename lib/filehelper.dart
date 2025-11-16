part of 'main.dart';

class FileHelper {
  final String _kPackageName = 'com.tsuna2001.ygobinder';
  final String _kImagesSubdir = 'images';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
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
    if(Platform.isAndroid) {
      final path = '/storage/emulated/0/Android/media/$_kPackageName/files/$_kImagesSubdir';

      try {
        final _ = Directory(path);
      }
      catch (e) {
        final _ = await Directory(path).create(recursive: true);
      }

      return File('$path/$id.jpg');
    }

    final deskPath = await _localPath;
    return File('$deskPath/images/$id.jpg');
  }

  Future<File> _exportableInventory() async {
    if(Platform.isAndroid) {
      final path = '/storage/emulated/0/Android/media/$_kPackageName/files/';

      try {
        final _ = Directory(path);
      }
      catch (e) {
        final _ = await Directory(path).create(recursive: true);
      }

      return File('$path/exported.json');
    }

    final deskPath = await _localPath;
    return File('$deskPath/exported.json');
  }

  Future<File> writeDataCache(String data) async {
    final file = await _localCache;
    return file.writeAsString(data);
  }

  Future<File> writeDataInventory(String data) async {
    final file = await _localInventory;
    return file.writeAsString(data);
  }

  Future<File> exportInventory(String data) async {
    final file = await _exportableInventory();
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

      if (!await file.exists()) throw Exception('No se pudo leer la imagen');

      final contents = await file.readAsBytes();
      return contents;
    } catch (e) {
      return null;
    }
  }
}