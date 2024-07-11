import 'package:todo_list_yandex_school_2024/data/models/task_model.dart';

abstract class ITaskRepository {
  Future<List<TaskModel>> getAllTasks(bool firstLaunch);
  Future<void> updateTasks(List<TaskModel> task);
  Future<TaskModel> getTask(String taskId);
  Future<TaskModel> addTask(TaskModel task);
  Future<TaskModel> changeTask(TaskModel task);
  Future<TaskModel> deleteTask(String taskId);

  List<TaskModel> get listOfTasks;
}
