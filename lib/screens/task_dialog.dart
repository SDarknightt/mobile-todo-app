import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:client/model/Task.dart';

import '../utils/status_color.dart';

class TaskDialog extends StatelessWidget {
  final Task task;

  TaskDialog({required this.task});

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
                child: Center(
                  child: TextButton(
                    child: Text('Voltar', style: TextStyle(color: Colors.green)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                )),
          ],
        ),
      )
    );
  }
}