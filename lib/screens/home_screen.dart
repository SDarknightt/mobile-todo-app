import 'package:client/services/task_service.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService authService = AuthService();
  final TaskService taskService = TaskService();
  List<dynamic> _tasks = [];

  @override
  void initState() {
    super.initState();
    fetchAndSetTasks();
  }

  Future<void> fetchAndSetTasks() async {
    try {
      final tasks = await taskService.getTasks();
      setState(() {
        _tasks = tasks;
      });
    } catch (error) {
      print('Erro ao buscar tarefas: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarefas', textAlign: TextAlign.center),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.circle, color: Colors.red),
            title: Text(_tasks[index]['title']),
            subtitle: Text(_tasks[index]['description']),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Tarefas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await authService.logOut();
            Navigator.pushReplacementNamed(context, "/");
          } catch (e) {
            print("Failed logout");
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}