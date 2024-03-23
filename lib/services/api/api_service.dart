import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080'; // URL base da API
  static String? token;

  static Future<http.Response> get(String endpoint) async {
    // Verifica se o token está definido antes de enviar a solicitação
    if (token != null) {
      return await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Authorization': 'Bearer $token'},
      );
    } else {
      // Se o token não estiver definido, envie a solicitação sem o cabeçalho de autorização
      return await http.get(Uri.parse('$baseUrl$endpoint'));
    }
  }

  static Future<http.Response> post(
      String endpoint, Map<String, dynamic> body) async {
    final headers = {
      'Content-Type':
          'application/json', // Definindo o tipo de conteúdo como JSON
      if (token != null) 'Authorization': 'Bearer $token',
    };

    return await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body), // Convertendo o corpo para JSON
    );
  }
}
