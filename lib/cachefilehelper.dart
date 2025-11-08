part of 'main.dart';

class CacheFileHelper {
  String localPath = '';
  // Obtener ruta al archivo
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    localPath = directory.path;
    return directory.path;
  }

  // Obtener la referencia
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/ygo_api_cache.json');
  }

  // Escribir los datos en un JSON
  Future<File> writeData(String data) async {
    final file = await _localFile;
    return file.writeAsString(data);
  }

  // Leer el contenido del archivo
  Future<String?> readData() async {
    try {
      final file = await _localFile;

      if (!await file.exists()) return null;

      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      return null;
    }
  }
}