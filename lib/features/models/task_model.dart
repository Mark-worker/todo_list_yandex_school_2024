enum TaskPriority {
  none,
  low,
  high;

  String get toNameString {
    return switch (this) {
      TaskPriority.none => "Нет",
      TaskPriority.low => "Низкий",
      TaskPriority.high => "!! Высокий",
    };
  }
}

class TaskModel {
  final int id;
  final String title;
  final TaskPriority priority;
  bool isDone;
  final DateTime? deadline;

  TaskModel({
    required this.id,
    required this.title,
    this.priority = TaskPriority.none,
    this.isDone = false,
    this.deadline,
  });
}
