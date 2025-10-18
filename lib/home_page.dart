import 'package:flutter/material.dart';
import 'db/tasks_database.dart';
import 'model/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TasksDatabase _tasksDatabase = TasksDatabase.instance;
  List<Task> _tasks = [];
  String? _newTask;

  @override
  void initState() {
    super.initState();
    _getAlltasks();
  }

  Future<void> _getAlltasks() async {
    final tasks = await _tasksDatabase.getAllTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  Future<void> _addTask() async {
    if (_newTask == null || _newTask!.trim().isEmpty) return;

    final newTaskObj = Task(description: _newTask!.trim(), isFinished: false);
    await _tasksDatabase.addNewTask(newTaskObj);
    _newTask = null;
    if (!mounted) return;
    Navigator.pop(context);
    await _getAlltasks();
  }

  Future<void> _updateTask(Task task, int index, bool isChecked) async {
    final updatedTask = task.copy(isFinished: isChecked);
    await _tasksDatabase.update(updatedTask);
    setState(() {
      _tasks[index] = updatedTask;
    });
  }

  Future<void> _deleteTask(int index) async {
    final task = _tasks[index];
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
        _tasks.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TO-DO List'),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Add Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) => _newTask = value,
                    decoration: const InputDecoration(
                      hintText: 'Task description...',
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _addTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Add Task'),
                  ),
                ],
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: _tasks.isEmpty
          ? const Center(child: Text('No tasks yet'))
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return InkWell(
                  onLongPress: () => _deleteTask(index),
                  child: Card(
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
                              task.isFinished
                                  ? '${task.description} (Done)'
                                  : task.description,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: task.isFinished
                                    ? Colors.red
                                    : Colors.black,
                              ),
                            ),
                          ),
                          Checkbox(
                            value: task.isFinished,
                            onChanged: (value) {
                              if (value != null) {
                                _updateTask(task, index, value);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
