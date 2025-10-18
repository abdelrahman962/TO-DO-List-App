const String tableTasks = 'tasks';

class TaskFields {
  static final List<String> values = [id, description, isFinished];

  static const String id = '_id';
  static const String description = 'description';
  static const String isFinished = 'isFinished';
}

class Task {
  final int? id;
  final String description;
  final bool isFinished;

  const Task({this.id, required this.description, required this.isFinished});

  Task copy({int? id, String? description, bool? isFinished}) => Task(
    id: id ?? this.id,

    description: description ?? this.description,
    isFinished: isFinished ?? this.isFinished,
  );

  static Task fromJson(Map<String, Object?> json) => Task(
    id: json[TaskFields.id] as int?,

    description: json[TaskFields.description] as String,
    isFinished: json[TaskFields.isFinished] == 1,
  );

  Map<String, Object?> toJson() => {
    TaskFields.id: id,

    TaskFields.description: description,
    TaskFields.isFinished: isFinished ? 1 : 0,
  };
}
