import 'package:dio/dio.dart';
import 'package:todo_list_yandex_school_2024/core/logger.dart';
import 'package:todo_list_yandex_school_2024/data/datasources/i_data_source.dart';
import 'dart:convert';

import 'package:todo_list_yandex_school_2024/data/models/task_model.dart';

class RemoteDataSource implements IDataSource {
  final Dio _dio;
  final String _baseUrl = "https://hive.mrdekk.ru/todo";
  final String bearerToken = "Salmar";
  int? _revision = 0;

  RemoteDataSource(this._dio);

  @override
  Future<List<TaskModel>> getAllTasks() async {
    _dio.options.headers["Authorization"] = "Bearer $bearerToken";
    final response = await _dio.get('$_baseUrl/list');
    if (response.statusCode == 200) {
      final data = response.data;
      logger.d(data);
      _revision = data["revision"];
      final tasks = (data['list'] as List)
          .map((task) => TaskModel.fromMap(task))
          .toList();
      return tasks;
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  @override
  Future<void> addTask(TaskModel task) async {
    logger.d(
      jsonEncode({"element": task.toMap()}),
    );
    final response = await _dio.post(
      '$_baseUrl/list',
      data: jsonEncode({"element": task.toMap()}),
      options: Options(headers: {
        'Content-Type': 'application/json',
        'X-Last-Known-Revision': _revision.toString()
      }),
    );
    _revision = response.data["revision"]++;
    if (response.statusCode != 200) {
      throw Exception('Failed to add task');
    }
  }

  @override
  Future<void> updateTasks(List<TaskModel> tasks) async {
    final response = await _dio.patch(
      '$_baseUrl/list',
      data: jsonEncode({
        "list": tasks
            .map(
              (elem) => elem.toMap(),
            )
            .toList()
      }),
      options: Options(headers: {
        'Content-Type': 'application/json',
        'X-Last-Known-Revision': _revision.toString()
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update task');
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    final response = await _dio.delete('$_baseUrl/list/$taskId');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }

  @override
  Future<void> changeTask(TaskModel task) async {
    final response = await _dio.put(
      '$_baseUrl/list/${task.id}',
      data: jsonEncode({"element": task.toMap()}),
      options: Options(headers: {
        'Content-Type': 'application/json',
        'X-Last-Known-Revision': _revision.toString()
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update task');
    }
    _revision = response.data["revision"];
  }

  @override
  Future<TaskModel> getTask(String taskId) async {
    final response = await _dio.get('$_baseUrl/list/$taskId');
    if (response.statusCode == 200) {
      final data = response.data;
      final task = TaskModel.fromMap(data["element"] as Map<String, dynamic>);
      return task;
    } else {
      throw Exception('Failed to get task');
    }
  }
}
