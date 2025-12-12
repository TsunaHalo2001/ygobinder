part of 'main.dart';

class FileHelper {
  final androidExportPath = '/storage/emulated/0/Android/media/com.tsuna2001.ygobinder/files';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Gets the app-specific external files directory for Android, or the app documents directory for others.
  Future<String> get _appStoragePath async {
    if (Platform.isAndroid) {
      // Using getExternalStorageDirectory is the correct way to get the app-specific files directory
      // on external storage. It doesn't require special permissions.
      return androidExportPath;
    }
    // Fallback for non-Android platforms or if external storage is not available.
    return _localPath;
  }

  Future<File> get _localCache async {
    final path = await _localPath;
    return File('$path/ygo_api_cache.json');
  }

  Future<File> get _localInventory async {
    final path = await _localPath;
    return File('$path/ygo_inventory.json');
  }

  Future<File> _localImage(int id) async {
    final path = await _appStoragePath;
    // This correctly creates the directory if it doesn't exist.
    await Directory(path).create(recursive: true);
    return File('$path/images/$id.jpg');
  }

  Future<File> _exportableInventory() async {
    final path = await _appStoragePath;
    // This correctly creates the directory if it doesn't exist.
    await Directory(path).create(recursive: true);
    return File('$path/exported.json');
  }

  Future<File> _fixedDocDir() async {
    final path = '/storage/emulated/0/Android/Documents/ygobinder';
    final date = DateTime.now();
    final formattedDate = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}_${date.hour.toString().padLeft(2, '0')}-${date.minute.toString().padLeft(2, '0')}';

    await Directory(path).create(recursive: true);
    return File('$path/exported$formattedDate.json');
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

  Future<File> exportInventoryToDocs(String data) async {
    final file = await _fixedDocDir();
    return file.writeAsString(data);
  }

  Future<File> writeImage(int id, Uint8List data) async {
    final file = await _localImage(id);
    return file.writeAsBytes(data);
  }

  Future<String?> readDataCache() async {
    try {
      final file = await _localCache;

      if (!await file.exists()) {
        await file.writeAsString('{}');

        return '{}';
      }

      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      return null;
    }
  }

  Future<String?> readDataInventory() async {
    try {
      final file = await _localInventory;

      if (!await file.exists()) {
        await file.writeAsString('{}');

        return '{}';
      }

      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      return null;
    }
  }

  Future<String?> importInventory() async {
    try {
      final path = await _appStoragePath;
      final file = File('$path/import.json');

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
