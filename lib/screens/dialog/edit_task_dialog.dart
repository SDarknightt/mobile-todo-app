import 'package:flutter/material.dart';
import 'package:client/model/Task.dart';
import 'package:client/services/task_service.dart';

class EditTaskDialog extends StatefulWidget {
  final Task task;
  final Function fetchAndSetTasks;

  EditTaskDialog({required this.task, required this. fetchAndSetTasks});

  @override
  _EditTaskDialogState createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.task.title;
    descriptionController.text = widget.task.description;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void updateTask() {
    if (_formKey.currentState!.validate()) {
      TaskService().updateTask(
        widget.task.id,
        titleController.text,
        descriptionController.text,
        widget.task.status,
      );
      widget.fetchAndSetTasks();
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Editar Tarefa'),
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
        TextButton(
          child: Text('Voltar', style: TextStyle(color: Colors.green)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Salvar', style: TextStyle(color: Colors.blue)),
          onPressed: updateTask,
        ),
      ],
    );
  }
}