import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../model/Task.dart';
import '../services/task_service.dart';
import '../utils/status_color.dart';
import 'edit_task_dialog.dart';

class TaskDialog extends StatefulWidget {
  final Task task;
  final Function fetchAndSetTasks;

  TaskDialog({required this.task, required this.fetchAndSetTasks});

  @override
  _TaskDialogState createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  File? _image;
  final taskService = TaskService();

  Future getImage() async {
    final ImageSource? source = await showDialog<ImageSource>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Selecione a origem da imagem'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () { Navigator.pop(context, ImageSource.camera); },
                child: const Text('Câmera'),
              ),
              SimpleDialogOption(
                onPressed: () { Navigator.pop(context, ImageSource.gallery); },
                child: const Text('Galeria'),
              ),
            ],
          );
        }
    );

    if (source != null) {
      final pickedFile = await ImagePicker().getImage(source: source);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          taskService.uploadImageTask(widget.task.id, _image!);
          widget.fetchAndSetTasks();
          Navigator.of(context).pop();
        } else {
          print('Nenhuma imagem foi selecionada.');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: getStatusColor(widget.task.status),
        body: AlertDialog(
          title: Center(child: Text(widget.task.title)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.task.description),
                if (widget.task.imageUrl != null && widget.task.imageUrl!.isNotEmpty)
                SizedBox(height:40),

                if (widget.task.imageUrl != null && widget.task.imageUrl!.isNotEmpty)
                Container(
                  height: 200,
                  width: 200,
                  child: Image.network('http://10.0.2.2:8080/${widget.task.imageUrl}', fit: BoxFit.cover),
                ),

              widget.task.imageUrl != null
                  ? TextButton(
                      onPressed: () {
                        taskService.removeImageTask(widget.task.id);
                        widget.fetchAndSetTasks();
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.photo_camera, color: Colors.red),
                          SizedBox(width: 5),
                          Text('Remover Imagem',
                              style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    )
                  : TextButton(
                      onPressed: getImage,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.photo_camera, color: Colors.grey),
                          SizedBox(width: 5),
                          Text('Adicionar Imagem',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
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
                          builder: (context) => EditTaskDialog(task: widget.task, fetchAndSetTasks: widget.fetchAndSetTasks),
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