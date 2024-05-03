import 'dart:convert';
import 'dart:io';

import 'package:client/model/Task.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'auth_service.dart';

class TaskService {
  final String baseUrl = 'http://10.0.2.2:8080';
  final AuthService authService = AuthService();

  Future<List<Task>> getTasks() async {
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
      return (data['data'] as List).map((task) => Task.fromJson(task)).toList();
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

  Future<Map<String, dynamic>> createTask(String title, String description) async {
    final token = await authService.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/task/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        'description': description
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao criar a tarefa');
    }
  }

  Future<void> deleteTask(String id) async {
    final token = await authService.getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/task/delete'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }, body: jsonEncode(<String, dynamic>{
        'id': id
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao deletar a tarefa');
    }
  }

  Future<void> updateTask(String id, String title, String description, String status) async {
    final token = await authService.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/task/edit'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'title': title,
        'description': description,
        'status': status
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao atualizar a tarefa');
    }
  }

  Future<void> uploadImageTask(String id, File image) async {
    final token = await authService.getToken();
    final url = Uri.parse('$baseUrl/task/upload');

    final request = http.MultipartRequest('POST', url)
      ..headers.addAll(<String, String>{
        'Authorization': 'Bearer $token',
      })
      ..fields['id'] = id
      ..files.add(await http.MultipartFile.fromPath(
        'image',
        image.path,
        contentType: MediaType('image', 'jpeg'),
      ));

    final response = await http.Response.fromStream(await request.send());

    if (response.statusCode != 200) {
      throw Exception('Falha ao enviar a imagem');
    }
  }

  Future<void> removeImageTask(String id) async {
    final token = await authService.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/task/remove'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao remover a imagem da tarefa');
    }
  }

}