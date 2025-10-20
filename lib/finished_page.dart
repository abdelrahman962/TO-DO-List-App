import 'package:flutter/material.dart';
import 'db/tasks_database.dart';
import 'model/task.dart';

class FinishedPage extends StatefulWidget {
  const FinishedPage({super.key});

  @override
  State<FinishedPage> createState() => _FinishedPageState();
}

class _FinishedPageState extends State<FinishedPage> {
  final TasksDatabase _tasksDatabase = TasksDatabase.instance;
  List<Task> _finished = [];

  @override
  void initState() {
    super.initState();
    _getDoneTasks();
  }

  Future<void> _getDoneTasks() async {
    final tasks = await _tasksDatabase.getAllTasks();
    setState(() {
      _finished = tasks.where((t) => t.isFinished).toList();
    });
  }

  Future<void> _deleteTask(int index) async {
    final task = _finished[index];
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Task?'),
        content: Text('Delete "${task.description}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirm ?? false) {
      await _tasksDatabase.delete(task.id!);
      setState(() {
        _finished.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight, // aligns to right
          child: const Text('Finished Tasks'),
        ),
        foregroundColor: Colors.white,

        backgroundColor: Colors.blue,
      ),
      body: _finished.isEmpty
          ? const Center(child: Text('No finished tasks yet.'))
          : ListView.builder(
              itemCount: _finished.length,
              itemBuilder: (context, index) {
                final task = _finished[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            task.description,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (value) {
                            if (value == 'delete') {
                              _deleteTask(index);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Delete'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
