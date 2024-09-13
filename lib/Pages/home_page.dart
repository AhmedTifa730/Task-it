import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_it/models/task_model.dart';
import 'package:task_it/widgets/button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box<Task> taskBox;

  @override
  void initState() {
    super.initState();
    taskBox = Hive.box<Task>('tasks');
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        toolbarHeight: deviceHeight * 0.2,
        title: const Text(
          'Task it!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
          ),
        ),
      ),
      body: taskView(),
      floatingActionButton: button(context),
    );
  }

  Widget taskView() {
    return ValueListenableBuilder(
      valueListenable: taskBox.listenable(),
      builder: (context, Box<Task> box, _) {
        if (box.isEmpty) {
          return const Center(child: Text('No tasks available'));
        } else {
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              Task task = box.getAt(index)!;
              return ListTile(
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration: task.completed
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                subtitle: Text(task.date.toString()),
                trailing: Icon(
                  task.completed
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  color: task.completed ? Colors.green : Colors.red,
                ),
                onTap: () {
                  setState(() {
                    task.completed = !task.completed;
                    task.save();
                  });
                },
                onLongPress: () {
                  // Show confirmation dialog before deleting the task
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Delete Task"),
                        content: const Text(
                            "Are you sure you want to delete this task?"),
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
                              setState(() {}); // Refresh UI after deletion
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
      },
    );
  }
}
