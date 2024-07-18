import "package:todo_list_yandex_school_2024/feature/data/models/task_model.dart";

abstract interface class IDataSource {
  Future<List<TaskModel>> getAllTasks();
  Future<List<TaskModel>> updateTasks(List<TaskModel> task);
  Future<TaskModel> getTask(String taskId);
  Future<TaskModel> addTask(TaskModel task);
  Future<TaskModel> changeTask(TaskModel task);
  Future<TaskModel> deleteTask(String taskId);
}
