part of 'main.dart';

class ApiService {
  final String _baseUrl = 'https://raw.githubusercontent.com/TsunaHalo2001/ygobinder/master/assets/json/ygo_api_cache.json';

  Future<void> signInWithGoogle() async {
    try {
      if(GoogleSignIn.instance.supportsAuthenticate()){
        /*final GoogleSignInAccount result = await GoogleSignIn.instance.authenticate(
          scopeHint: ['email', 'profile'],
        );*/
        //final googleKey = result.authentication;
        /*final GoogleSignInClientAuthorization? auth
          = await result.authorizationClient.authorizationForScopes(
            ['email', 'profile'],
          );*/
      }
    } catch (e) {
      throw Exception('Error al iniciar sesión con Google: $e');
    }
  }

  Future<Map<String, dynamic>> fetchData(String endpoint) async {
    final uri = Uri.parse('$_baseUrl$endpoint');

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