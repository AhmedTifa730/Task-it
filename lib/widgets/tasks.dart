import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_it/models/task_model.dart';

Widget task(Box<Task> box) {
  if (box.isEmpty) {
    return const Center(child: Text("No tasks available."));
  }

  return ListView.builder(
    itemCount: box.length,
    itemBuilder: (context, index) {
      final task = box.getAt(index);

      if (task == null) return const SizedBox(); 

      return ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.completed
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Text(
          task.date.toString(),
        ),
        trailing: Icon(
          task.completed ? Icons.check_box : Icons.check_box_outline_blank,
          color: task.completed ? Colors.green : Colors.red,
        ),
        onTap: () {
          // Toggle task completion on tap
          task.completed = !task.completed;
          task.save(); // Save the updated task to Hive
        },
        onLongPress: () {
          // Show confirmation dialog before deleting the task
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Delete Task"),
                content: const Text("Are you sure you want to delete this task?"),
                actions: [
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                    },
                  ),
                  TextButton(
                    child: const Text("Delete"),
                    onPressed: () {
                      box.deleteAt(index); // Delete task from Hive box
                      Navigator.of(context).pop(); // Close dialog
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    },
  );
}

Widget taskView() {
  // Access the Hive box safely
  final box = Hive.box<Task>('tasks');

  if (box.isEmpty) {
    return const Center(child: CircularProgressIndicator());
  }

  return ValueListenableBuilder(
    valueListenable: box.listenable(),
    builder: (context, Box<Task> box, _) {
      return task(box); // Call the task widget with the updated box
    },
  );
}
