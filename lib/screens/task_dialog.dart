import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:client/model/Task.dart';

import '../utils/status_color.dart';
import 'edit_task_dialog.dart';

class TaskDialog extends StatelessWidget {
  final Task task;
  final Function fetchAndSetTasks;

  TaskDialog({required this.task, required this.fetchAndSetTasks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getStatusColor(task.status),
      body: AlertDialog(
        title: Center(child: Text(task.title)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(task.description),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: Text('Voltar', style: TextStyle(color: Colors.green)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Editar', style: TextStyle(color: Colors.blue)),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditTaskDialog(task: task, fetchAndSetTasks: fetchAndSetTasks),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}