import 'package:todo_list_yandex_school_2024/feature/data/models/task_model.dart';

sealed class TaskListState {}

class EmptyState extends TaskListState {}

class LoadingState extends TaskListState {
  final List<TaskModel> oldTasksList;
  final bool isFirstFetch;

  LoadingState(this.oldTasksList, {this.isFirstFetch = false});
}

class ErrorState extends TaskListState {
  final String exception;

  ErrorState(this.exception);
}

class LoadedState extends TaskListState {
  final List<TaskModel> listOfTasks;

  LoadedState(this.listOfTasks);
}
