import 'package:todo_list_yandex_school_2024/data/models/task_model.dart';

abstract class IGetAllTasks {
  Future<List<TaskModel>> call();
}

abstract class IAddTask {
  Future<void> call(TaskModel task);
}

abstract class IUpdateTasks {
  Future<void> call(List<TaskModel> tasks);
}

abstract class IDeleteTask {
  Future<void> call(String taskId);
}

abstract class IChangeTask {
  Future<void> call(TaskModel task);
}

abstract class IGetTask {
  Future<TaskModel> call(String taskId);
}