import 'package:todo_list_yandex_school_2024/data/models/task_model.dart';

sealed class MainPageState {}

class EmptyState implements MainPageState {}

class LoadingState implements MainPageState {}

class ErrorState implements MainPageState {
  final Exception exception;

  ErrorState(this.exception);
}

class LoadedState implements MainPageState {
  final List<TaskModel> listOfTasks;

  LoadedState(this.listOfTasks);
}
