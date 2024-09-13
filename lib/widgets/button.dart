import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_it/models/task_model.dart';
import 'package:task_it/models/display_task.dart';

Widget button(BuildContext context) {
  return FloatingActionButton(
    onPressed: () {
      displayTask(context, (String taskTitle) {
        final taskBox = Hive.box<Task>('tasks');
        final newTask = Task(
          taskTitle, 
          DateTime.now(), // Current date/time
          false, // Task is not completed initially
        );
        taskBox.add(newTask); // Save the new task to Hive
      });
    },
    backgroundColor: Colors.redAccent,
    child: const Icon(
      Icons.add,
    ),
  );
}
