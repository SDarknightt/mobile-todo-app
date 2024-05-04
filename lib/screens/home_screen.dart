import 'dart:async';

import 'package:client/model/Task.dart';
import 'package:client/screens/task_dialog.dart';
import 'package:client/services/task_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../services/auth_service.dart';
import '../utils/status_color.dart';
import 'create_task_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService authService = AuthService();
  final TaskService taskService = TaskService();
  List<Task> _tasks = [];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  Timer? _timer;

  Future<void> createTask() async {
    if (_formKey.currentState!.validate()) {
      try {
        await taskService.createTask(
          titleController.text,
          descriptionController.text
        );
        titleController.clear();
        descriptionController.clear();
        fetchAndSetTasks();
        Navigator.of(context).pop();
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAndSetTasks();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      fetchAndSetTasks();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
                print(value);
              },
              decoration: InputDecoration(
                labelText: 'Buscar',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30)
                ),
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
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: ListTile(
                    leading: Icon(Icons.circle, color: getStatusColor(_tasks[index].status)),
                    title: Text(_tasks[index].title),
                    subtitle: Text(_tasks[index].description),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => TaskDialog(task: _tasks[index], fetchAndSetTasks: fetchAndSetTasks),
                      );
                    },
                  ),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Excluir',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () async {
                        try {
                          await taskService.deleteTask(_tasks[index].id);
                          fetchAndSetTasks();
                        } catch (error) {
                          print('Erro ao deletar tarefa: $error');
                        }
                      },
                    ),
                    IconSlideAction(
                      caption: 'Editar',
                      color: Colors.blue,
                      icon: Icons.edit,
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading: Icon(Icons.circle, color: Colors.red),
                                    title: Text('Fazer'),
                                    onTap: () async {
                                      await taskService.updateTask(
                                          _tasks[index].id,
                                          _tasks[index].title,
                                          _tasks[index].description,
                                          'TODO'
                                      );
                                      fetchAndSetTasks();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.circle, color: Colors.yellow),
                                    title: Text('Fazendo'),
                                    onTap: () async {
                                      await taskService.updateTask(
                                          _tasks[index].id,
                                          _tasks[index].title,
                                          _tasks[index].description,
                                          'DOING'
                                      );
                                      fetchAndSetTasks();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.circle, color: Colors.green),
                                    title: Text('Feito'),
                                    onTap: () async {
                                      await taskService.updateTask(
                                          _tasks[index].id,
                                          _tasks[index].title,
                                          _tasks[index].description,
                                          'DONE'
                                      );
                                      fetchAndSetTasks();
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            }
                        );
                      },
                    ),
                  ],
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
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => CreateTaskDialog(fetchAndSetTasks: fetchAndSetTasks),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}