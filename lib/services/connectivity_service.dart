import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class ConnectivityService {
  static final Connectivity _connectivity = Connectivity();

  /// Verifica si hay conexión a internet
  static Future<bool> hasInternetConnection() async {
    try {
      // Primero verifica la conectividad
      final connectivityResult = await _connectivity.checkConnectivity();
      
      if (connectivityResult.contains(ConnectivityResult.none)) {
        return false;
      }

      // Luego verifica si realmente hay acceso a internet
      try {
        final response = await http.get(
          Uri.parse('https://www.google.com'),
        ).timeout(
          const Duration(seconds: 5),
        );
        return response.statusCode == 200;
      } catch (_) {
        return false;
      }
    } catch (e) {
      print('Error verificando conexión: $e');
      return false;
    }
  }

  /// Stream que escucha cambios en la conectividad
  static Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.asyncMap((_) async {
      return await hasInternetConnection();
    });
  }
}
