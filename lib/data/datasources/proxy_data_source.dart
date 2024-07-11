import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:todo_list_yandex_school_2024/core/logger.dart';
import 'package:todo_list_yandex_school_2024/data/datasources/i_data_source.dart';
import 'package:todo_list_yandex_school_2024/data/datasources/local_data_source.dart';
import 'package:todo_list_yandex_school_2024/data/datasources/remote_data_source.dart';
import 'package:todo_list_yandex_school_2024/data/models/task_model.dart';

class ProxyDataSource implements IDataSource {
  final LocalDataSource _localDataSource;
  final RemoteDataSource _remoteDataSource;

  ProxyDataSource(this._localDataSource, this._remoteDataSource);

  List<TaskModel> get listOfTasks {
    return _localDataSource.currentListOfTasks;
  }

  void updateLocalRevision() {
    final int revision = _remoteDataSource.revision!;
    _localDataSource.setLocalRevision(revision);
  }

  @override
  Future<List<TaskModel>> getAllTasks() async {
    bool hasConnection = await InternetConnectionChecker().hasConnection;
    if (hasConnection) {
      List<TaskModel> tasks = await _remoteDataSource.getAllTasks();
      int currentLocalRevision = await _localDataSource.getLocalRevision();
      int currentRemoteRevision = _remoteDataSource.revision!;
      logger.d(
          "revision remote: ${_remoteDataSource.revision} \n revision local: ${await _localDataSource.getLocalRevision()}");
      if (currentLocalRevision != currentRemoteRevision) {
        logger.d("different revisions! merging lists...");
        tasks = await _remoteDataSource
            .updateTasks(await _localDataSource.getAllTasks());
      }
      _localDataSource.saveTasks(tasks);
      _localDataSource.setLocalRevision(_remoteDataSource.revision!);
    }
    return await _localDataSource.getAllTasks();
  }

  @override
  Future<TaskModel> addTask(TaskModel task) async {
    bool hasConnection = await InternetConnectionChecker().hasConnection;
    logger.d("remote revision: ${_remoteDataSource.revision}");
    logger.d("local revision: ${await _localDataSource.getLocalRevision()}");

    if (hasConnection) {
      await _remoteDataSource.addTask(task);
      _localDataSource.setLocalRevision(_remoteDataSource.revision!);
    }
    return await _localDataSource.addTask(task);
  }

  @override
  Future<List<TaskModel>> updateTasks(List<TaskModel> tasks) async {
    bool hasConnection = await InternetConnectionChecker().hasConnection;
    if (hasConnection) {
      await _remoteDataSource.updateTasks(tasks);
    }
    return await _localDataSource.updateTasks(tasks);
  }

  @override
  Future<TaskModel> deleteTask(String taskId) async {
    bool hasConnection = await InternetConnectionChecker().hasConnection;
    if (hasConnection) {
      await _remoteDataSource.deleteTask(taskId);
      _localDataSource.setLocalRevision(_remoteDataSource.revision!);
    }
    return await _localDataSource.deleteTask(taskId);
  }

  @override
  Future<TaskModel> changeTask(TaskModel task) async {
    bool hasConnection = await InternetConnectionChecker().hasConnection;
    if (hasConnection) {
      await _remoteDataSource.changeTask(task);
      _localDataSource.setLocalRevision(_remoteDataSource.revision!);
    }
    return await _localDataSource.changeTask(task);
  }

  @override
  Future<TaskModel> getTask(String taskId) async {
    bool hasConnection = await InternetConnectionChecker().hasConnection;
    if (hasConnection) {
      await _remoteDataSource.getTask(taskId);
    }
    return await _localDataSource.getTask(taskId);
  }
}
