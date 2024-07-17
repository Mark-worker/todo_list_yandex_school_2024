import "package:dio/dio.dart";
import "package:todo_list_yandex_school_2024/core/logger.dart";
import "package:todo_list_yandex_school_2024/feature/data/datasources/i_data_source.dart";
import "dart:convert";

import "package:todo_list_yandex_school_2024/feature/data/models/task_model.dart";

class RemoteDataSource implements IDataSource {
  Dio createDio(String bearerToken, String baseUrl) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
      ),
    );
    return _dio;
  }

  final String _bearerToken = "Salmar";
  final String _baseUrl = "https://hive.mrdekk.ru/todo";
  late Dio _dio = createDio(_bearerToken, _baseUrl);
  int? _revision = 0;
  List<TaskModel> _currentListOfTasks = [];

  int? get revision => _revision;

  @override
  RemoteDataSource();

  @override
  Future<List<TaskModel>> getAllTasks() async {
    final response = await _dio.get("/list");
    if (response.statusCode == 200) {
      final data = response.data;
      _revision = data["revision"];
      final currentListOfTasks = (data["list"] as List)
          .map((task) => TaskModel.fromMap(task))
          .toList();
      currentListOfTasks.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      return currentListOfTasks;
    } else {
      throw Exception("Failed to load tasks");
    }
  }

  @override
  Future<TaskModel> addTask(TaskModel task) async {
    logger.d("Called remote addTask");
    final response = await _dio.post(
      "/list",
      data: jsonEncode({"element": task.toMap()}),
      options: Options(
        headers: {
          "X-Last-Known-Revision": _revision.toString(),
        },
      ),
    );
    _revision = response.data["revision"];
    if (response.statusCode == 200) {
      final task =
          TaskModel.fromMap(response.data["element"] as Map<String, dynamic>);
      _currentListOfTasks.add(task);
      return task;
    } else {
      throw Exception("Failed to add task");
    }
  }

  @override
  Future<List<TaskModel>> updateTasks(List<TaskModel> tasks) async {
    final response = await _dio.patch(
      "/list",
      data: jsonEncode(
        {
          "list": tasks
              .map(
                (elem) => elem.toMap(),
              )
              .toList()
        },
      ),
      options: Options(
        headers: {
          "X-Last-Known-Revision": _revision.toString(),
        },
      ),
    );
    if (response.statusCode == 200) {
      final listOfTasks = (response.data["list"] as List)
          .map((task) => TaskModel.fromMap(task))
          .toList();
      _currentListOfTasks = listOfTasks;
      _revision = response.data["revision"];
      return listOfTasks;
    } else {
      throw Exception("Failed to update task");
    }
  }

  @override
  Future<TaskModel> deleteTask(String taskId) async {
    final response = await _dio.delete(
      "/list/$taskId",
      options:
          Options(headers: {"X-Last-Known-Revision": _revision.toString()}),
    );
    if (response.statusCode == 200) {
      _revision = response.data["revision"];
      final task =
          TaskModel.fromMap(response.data["element"] as Map<String, dynamic>);
      return task;
    } else {
      throw Exception("Failed to delete task");
    }
  }

  @override
  Future<TaskModel> changeTask(TaskModel task) async {
    final response = await _dio.put(
      "/list/${task.id}",
      data: jsonEncode({"element": task.toMap()}),
      options:
          Options(headers: {"X-Last-Known-Revision": _revision.toString()}),
    );
    if (response.statusCode == 200) {
      _revision = response.data["revision"];
      final task =
          TaskModel.fromMap(response.data["element"] as Map<String, dynamic>);
      return task;
    } else {
      throw Exception("Failed to update task");
    }
  }

  @override
  Future<TaskModel> getTask(String taskId) async {
    final response = await _dio.get("/list/$taskId");
    if (response.statusCode == 200) {
      final data = response.data;
      final task = TaskModel.fromMap(data["element"] as Map<String, dynamic>);
      return task;
    } else {
      throw Exception("Failed to get task");
    }
  }
}
