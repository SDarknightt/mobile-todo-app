import 'package:client/model/Task.dart';
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
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    fetchAndSetTasks();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'TODO':
        return Colors.red;
      case 'DOING':
        return Colors.yellow;
      case 'DONE':
        return Colors.green;
      default:
        return Colors.grey;
    }
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                // Implemente a lógica de filtragem aqui
              },
              decoration: InputDecoration(
                labelText: 'Buscar',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Icon(Icons.circle, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Fazer'),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.circle, color: Colors.yellow),
                  SizedBox(width: 8),
                  Text('Fazendo'),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.circle, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Feito'),
                ],
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.circle, color: getStatusColor(_tasks[index].status)),
                  title: Text(_tasks[index].title),
                  subtitle: Text(_tasks[index].description),
                );
              },
            ),
          ),
        ],
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
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              Navigator.pushReplacementNamed(context, '/profile') as Route<Object?>
            );
          }
        },
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