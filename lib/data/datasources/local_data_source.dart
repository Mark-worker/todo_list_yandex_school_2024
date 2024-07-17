import 'dart:convert';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list_yandex_school_2024/core/logger.dart';
import 'package:todo_list_yandex_school_2024/data/datasources/i_data_source.dart';
import 'package:todo_list_yandex_school_2024/data/models/task_model.dart';

class LocalDataSource implements IDataSource {
  static const String _tasksKey = 'tasks_key';
  static const String _revisionKey = 'revision_key';

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<TaskModel> _currentListOfTasks = [];

  List<TaskModel> get currentListOfTasks => _currentListOfTasks;

  Future<bool> hasConnection() async {
    return await InternetConnectionChecker().hasConnection;
  }

  @override
  Future<TaskModel> addTask(TaskModel task) async {
    // logger.d("Called local addTask");
    // logger.d("length of list of tasks before: ${_currentListOfTasks.length}");
    _currentListOfTasks.add(task);
    await saveTasks(_currentListOfTasks);
    setLocalRevision((await getLocalRevision()) + 1);
    // logger.d("length of list of tasks after: ${_currentListOfTasks.length}");
    return task;
  }

  @override
  Future<TaskModel> changeTask(TaskModel task) async {
    final tasks = _currentListOfTasks;
    logger.d(tasks);
    logger.d(task.id);
    for (TaskModel element in tasks) {
      logger.d(element.id);
    }
    final taskId = tasks.indexWhere((elem) => elem.id == task.id);
    logger.d(taskId);
    tasks[taskId] = task;
    await saveTasks(tasks);
    setLocalRevision((await getLocalRevision()) + 1);
    return task;
  }

  @override
  Future<TaskModel> deleteTask(String taskId) async {
    final tasks = _currentListOfTasks;
    for (int i = 0; i < tasks.length; i++) {
      final task = tasks[i];
      if (task.id == taskId) {
        tasks.remove(task);
        await saveTasks(tasks);
        return task;
      }
    }
    setLocalRevision((await getLocalRevision()) + 1);
    throw Exception("Couldn't delete task from local repository");
  }

  @override
  Future<List<TaskModel>> getAllTasks(bool _) async {
    final prefs = await _prefs;
    final tasksString = prefs.getString(_tasksKey);
    if (tasksString == null) {
      return [];
    }
    final List<dynamic> tasksJson = jsonDecode(tasksString);
    _currentListOfTasks =
        tasksJson.map((json) => TaskModel.fromMap(json)).toList();
    for (TaskModel elem in _currentListOfTasks) {
      logger.d(elem.toMap());
    }
    _currentListOfTasks.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return _currentListOfTasks;
  }

  @override
  Future<TaskModel> getTask(String taskId) async {
    final TaskModel task =
        _currentListOfTasks.where((elem) => elem.id == taskId).first;
    return task;
  }

  @override
  Future<List<TaskModel>> updateTasks(List<TaskModel> tasks) async {
    await saveTasks(tasks);
    _currentListOfTasks = tasks;
    setLocalRevision((await getLocalRevision()) + 1);
    return _currentListOfTasks;
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
