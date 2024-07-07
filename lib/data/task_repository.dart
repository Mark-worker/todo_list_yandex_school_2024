import 'package:todo_list_yandex_school_2024/data/datasources/local_data_source.dart';
import 'package:todo_list_yandex_school_2024/data/datasources/proxy_data_source.dart';
import 'package:todo_list_yandex_school_2024/data/datasources/remote_data_source.dart';
import 'package:todo_list_yandex_school_2024/data/models/task_model.dart';
import 'package:todo_list_yandex_school_2024/domain/i_task_repository.dart';

class TaskRepository implements ITaskRepository {
  final ProxyDataSource _proxyDataSource;
  List<TaskModel> _currentListOfTasks = [];

  TaskRepository(
      LocalDataSource localDataSource, RemoteDataSource remoteDataSource)
      : _proxyDataSource = ProxyDataSource(localDataSource, remoteDataSource);

  @override
  List<TaskModel> get listOfTasks => _proxyDataSource.listOfTasks;

  @override
  Future<List<TaskModel>> getAllTasks() async {
    try {
      _currentListOfTasks = await _proxyDataSource.getAllTasks();
      return _currentListOfTasks;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addTask(TaskModel task) async {
    try {
      await _proxyDataSource.addTask(task);
      _currentListOfTasks.add(task);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateTasks(List<TaskModel> tasks) async {
    try {
      _currentListOfTasks = await _proxyDataSource.updateTasks(tasks);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      await _proxyDataSource.deleteTask(taskId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> changeTask(TaskModel task) async {
    try {
      await _proxyDataSource.changeTask(task);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TaskModel> getTask(String taskId) async {
    try {
      return await _proxyDataSource.getTask(taskId);
    } catch (e) {
      rethrow;
    }
  }
}
