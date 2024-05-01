import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/User.dart';

class AuthService {
  final String baseUrl = 'http://10.0.2.2:8080';

  //para testar se o token realmente está sendo salvo
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<User> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      final parts = token.split('.');
      if (parts.length != 3) {
        throw Exception('Token inválido');
      }

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final resp = utf8.decode(base64Url.decode(normalized));

      final data = jsonDecode(resp) as Map<String, dynamic>;
      return User.fromJson(data);
    } else {
      throw Exception('Nenhum token encontrado');
    }
  }

  Future<void> logOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      print("TOKEN REMOVIDO: ");
      print(getToken());
    } catch (e) {
      print("Failed logout");
    }
  }


  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('\n\n\nReceived response:\n ${response.body}\n\n');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      return data;
    } else {
      throw Exception('Failed to login');
    }
  }



  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'password': password,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register');
    }
  }
}