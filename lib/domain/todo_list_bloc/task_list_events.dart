import 'package:todo_list_yandex_school_2024/data/models/task_model.dart';

sealed class TaskListEvent {}

class FetchDataEvent extends TaskListEvent {}

class UpdateTaskEvent extends TaskListEvent {
  final TaskModel task;

  UpdateTaskEvent(this.task);
}

class AddTaskEvent extends TaskListEvent {
  final TaskModel task;

  AddTaskEvent(this.task);
}

class DeleteTaskEvent extends TaskListEvent {
  final TaskModel task;

  DeleteTaskEvent(this.task);
}
