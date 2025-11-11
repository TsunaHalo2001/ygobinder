part of 'main.dart';

class ApiService {
  final String _baseUrl = 'https://raw.githubusercontent.com/TsunaHalo2001/ygobinder/refs/heads/master/assets/json/ygo_api_cache.json';

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
}