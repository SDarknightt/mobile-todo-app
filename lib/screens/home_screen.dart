import 'package:client/model/Task.dart';
import 'package:client/services/task_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../services/auth_service.dart';

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
            builder: (context) {
              return AlertDialog(
                title: Text('Criar Tarefa'),
                content: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: titleController,
                            decoration: InputDecoration(labelText: 'Título'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira um título';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: descriptionController,
                            decoration: InputDecoration(labelText: 'Descrição'),
                          ),
                        ],
                    )
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text('Voltar', style: TextStyle(color: Colors.green)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.green,
                      ),
                      child: Text('Criar'),
                      onPressed: createTask,
                    ),
                  ),
                ],
              );
            },
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