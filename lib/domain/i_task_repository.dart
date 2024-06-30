import 'package:todo_list_yandex_school_2024/data/models/task_model.dart';

abstract class ITaskRepository {
  Future<List<TaskModel>> getAllTasks();
  Future<void> updateTasks(List<TaskModel> task);
  Future<TaskModel> getTask(String taskId);
  Future<void> addTask(TaskModel task);
  Future<void> changeTask(TaskModel task);
  Future<void> deleteTask(String taskId);
}
