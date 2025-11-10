part of 'main.dart';

class ApiService {
  final String _baseUrl = 'https://db.ygoprodeck.com/api/v7/cardinfo.php';

  Future<Map<String, dynamic>> fetchData(String endpoint) async {
    final uri = Uri.parse('$_baseUrl?$endpoint');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception(
            'Fallo al cargar datos: Código ${response.statusCode}'
        );
      }
    } catch (e) {
      throw Exception('Error de conexión o de red: $e');
    }
  }

  Future<Uint8List> fetchImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception(
            'Fallo al cargar la imagen: Código ${response.statusCode}'
        );
      }
    } catch (e) {
      throw Exception('Error de conexión o de red: $e');
      }

  }
}