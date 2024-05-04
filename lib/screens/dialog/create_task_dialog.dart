import 'package:flutter/material.dart';
import 'package:client/services/task_service.dart';

class CreateTaskDialog extends StatefulWidget {
  final Function fetchAndSetTasks;

  CreateTaskDialog({required this.fetchAndSetTasks});

  @override
  _CreateTaskDialogState createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends State<CreateTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void createTask() {
    if (_formKey.currentState!.validate()) {
      TaskService().createTask(
        titleController.text,
        descriptionController.text,
      );
      widget.fetchAndSetTasks();
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Criar Tarefa'),
      content: Form(
        key: _formKey,
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
        ),
      ),
      actions: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                child: Text('Voltar', style: TextStyle(color: Colors.green)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Criar', style: TextStyle(color: Colors.blue)),
                onPressed: createTask,
              ),
            ],
          ),
        ),
      ],
    );
  }
}