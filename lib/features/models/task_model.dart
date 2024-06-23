enum Priority { low, medium, high }

class TaskModel {
  final int id;
  final String title;
  final Priority priority;
  bool isDone;
  final DateTime? deadline;

  TaskModel({
    required this.id,
    required this.title,
    required this.priority,
    this.isDone = false,
    this.deadline,
  });
}
