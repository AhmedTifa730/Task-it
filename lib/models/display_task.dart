import 'package:flutter/material.dart';

void displayTask(BuildContext context, Function(String) onTaskAdded) {
  String taskTitle = '';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Add New Task!',
          style: TextStyle(color: Colors.red),
        ),
        content: TextField(
          onChanged: (value) {
            taskTitle = value;
          },
          decoration: const InputDecoration(
            hintText: 'Enter Task Title',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (taskTitle.isNotEmpty) {
                onTaskAdded(taskTitle); // Add the new task
              }
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Add'),
          ),
        ],
      );
    },
  );
}
