import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list_yandex_school_2024/core/logger.dart';
import 'package:todo_list_yandex_school_2024/data/datasources/i_data_source.dart';
import 'package:todo_list_yandex_school_2024/data/models/task_model.dart';

class LocalDataSource implements IDataSource {
  static const String _tasksKey = 'tasks_key';
  static const String _revisionKey = 'revision_key';

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Future<void> addTask(TaskModel task) async {
    final tasks = await getAllTasks();
    tasks.add(task);
    await saveTasks(tasks);
  }

  @override
  Future<void> changeTask(TaskModel task) async {
    final tasks = await getAllTasks();
    final taskId = tasks.indexWhere((elem) => elem.id == task.id);
    tasks[taskId] = task;
    await saveTasks(tasks);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    final tasks = await getAllTasks();
    tasks.removeWhere((task) => task.id == taskId);
    await saveTasks(tasks);
  }

  @override
  Future<List<TaskModel>> getAllTasks() async {
    final prefs = await _prefs;
    final tasksString = prefs.getString(_tasksKey);
    if (tasksString == null) {
      return [];
    }
    final List<dynamic> tasksJson = jsonDecode(tasksString);
    logger.d(tasksJson);
    return tasksJson.map((json) => TaskModel.fromMap(json)).toList();
  }

  @override
  Future<TaskModel> getTask(String taskId) async {
    final List<TaskModel> tasks = await getAllTasks();
    final TaskModel task =
        tasks.where((elem) => elem.id.toString() == taskId).first;
    return task;
  }

  @override
  Future<void> updateTasks(List<TaskModel> tasks) async {
    await saveTasks(tasks);
  }

  Future<void> saveTasks(List<TaskModel> tasks) async {
    final prefs = await _prefs;
    final String tasksString =
        jsonEncode(tasks.map((task) => task.toMap()).toList());
    await prefs.setString(_tasksKey, tasksString);
  }

  Future<int> getLocalRevision() async {
    final prefs = await _prefs;
    return prefs.getInt(_revisionKey) ?? 0;
  }

  Future<void> setLocalRevision(int revision) async {
    final prefs = await _prefs;
    await prefs.setInt(_revisionKey, revision);
  }
}
