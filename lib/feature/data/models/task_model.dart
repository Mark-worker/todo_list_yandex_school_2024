import "dart:convert";

class TaskModel {
  final String id;
  final String text;
  final TaskPriority priority;
  final DateTime? deadline;
  final bool isDone;
  final String? hexColor;
  final DateTime createdAt;
  final DateTime changedAt;
  final String phoneIdentifier;

  TaskModel(
      {required this.id,
      required this.text,
      required this.priority,
      this.deadline,
      required this.isDone,
      this.hexColor,
      required this.createdAt,
      required this.changedAt,
      required this.phoneIdentifier,});

  TaskModel copyWith({
    String? id,
    String? text,
    TaskPriority? priority,
    DateTime? deadline,
    bool? isDone,
    String? hexColor,
    DateTime? createdAt,
    DateTime? changedAt,
    String? phoneIdentifier,
  }) {
    return TaskModel(
      id: id ?? this.id,
      text: text ?? this.text,
      priority: priority ?? this.priority,
      deadline: deadline == null
          ? this.deadline
          : (deadline.millisecondsSinceEpoch == 0)
              ? null
              : deadline,
      isDone: isDone ?? this.isDone,
      hexColor: hexColor ?? this.hexColor,
      createdAt: createdAt ?? this.createdAt,
      changedAt: changedAt ?? this.changedAt,
      phoneIdentifier: phoneIdentifier ?? this.phoneIdentifier,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "text": text,
      "importance": priority.toJson,
      "deadline": deadline?.millisecondsSinceEpoch,
      "done": isDone,
      "color": hexColor,
      "created_at": createdAt.millisecondsSinceEpoch,
      "changed_at": changedAt.millisecondsSinceEpoch,
      "last_updated_by": phoneIdentifier,
    };
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    TaskPriority priority;
    switch (map["importance"]) {
      case "low":
        priority = TaskPriority.none;
      case "basic":
        priority = TaskPriority.low;
      case "important":
        priority = TaskPriority.high;
      default:
        priority = TaskPriority.none;
    }
    return TaskModel(
        id: map["id"] as String,
        text: map["text"] as String,
        priority: priority,
        deadline: map["deadline"] != null
            ? DateTime.fromMillisecondsSinceEpoch(map["deadline"] as int)
            : null,
        isDone: map["done"] as bool,
        hexColor: map["color"] != null ? (map["color"] as String) : null,
        createdAt:
            DateTime.fromMillisecondsSinceEpoch(map["created_at"] as int),
        changedAt:
            DateTime.fromMillisecondsSinceEpoch(map["changed_at"] as int),
        phoneIdentifier: map["last_updated_by"] as String,);
  }

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

enum TaskPriority {
  none,
  low,
  high;

  String get toJson {
    return switch (this) {
      TaskPriority.none => "low",
      TaskPriority.low => "basic",
      TaskPriority.high => "important",
    };
  }
}
