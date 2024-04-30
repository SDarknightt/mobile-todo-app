import 'dart:convert';

import 'package:http/http.dart' as http;

import 'auth_service.dart';

class TaskService {
  final String baseUrl = 'http://10.0.2.2:8080';
  final AuthService authService = AuthService();

  Future<List<dynamic>> getTasks() async {
    final token = await authService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/task/getall'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<dynamic>.from(data['data']);
    } else {
      throw Exception('Erro ao carregar as tarefas');
    }
  }

  Future<Map<String, dynamic>> getTaskById(String id) async {
    final token = await authService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/task/details'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao carregar a tarefa');
    }
  }

  Future<Map<String, dynamic>> createTask(String title, String description, String status) async {
    final token = await authService.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/tasks'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        'description': description,
        'status': status,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao criar a tarefa');
    }
  }
}