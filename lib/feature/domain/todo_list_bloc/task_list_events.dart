import 'package:todo_list_yandex_school_2024/feature/data/models/task_model.dart';

sealed class TaskListEvent {}

class FetchDataEvent extends TaskListEvent {
  final bool firstLaunch;

  FetchDataEvent({this.firstLaunch = false});
}

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
