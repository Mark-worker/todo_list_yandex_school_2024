import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_list_yandex_school_2024/data/datasources/local_data_source.dart';
import 'package:todo_list_yandex_school_2024/data/datasources/proxy_data_source.dart';
import 'package:todo_list_yandex_school_2024/data/datasources/remote_data_source.dart';
import 'package:todo_list_yandex_school_2024/data/task_repository.dart';
import 'package:todo_list_yandex_school_2024/domain/use_cases/i_use_cases.dart';
import 'package:todo_list_yandex_school_2024/domain/use_cases/use_cases.dart';
import 'package:uuid/uuid.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Register data sources
  getIt.registerLazySingleton<LocalDataSource>(() => LocalDataSource());
  getIt.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSource(getIt<Dio>()));
  getIt.registerLazySingleton<ProxyDataSource>(() => ProxyDataSource(
        getIt<LocalDataSource>(),
        getIt<RemoteDataSource>(),
      ));

  // Register repository
  getIt.registerLazySingleton<TaskRepository>(() =>
      TaskRepository(getIt<LocalDataSource>(), getIt<RemoteDataSource>()));

  // Register use cases
  getIt.registerLazySingleton<UseCases>(() => UseCases(
        getAllTasks: GetAllTasks(getIt<TaskRepository>()),
        addTask: AddTask(getIt<TaskRepository>()),
        updateTasks: UpdateTasks(getIt<TaskRepository>()),
        deleteTask: DeleteTask(getIt<TaskRepository>()),
        changeTask: ChangeTask(getIt<TaskRepository>()),
        getTask: GetTask(getIt<TaskRepository>()),
      ));

  //Register external
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<Uuid>(() => const Uuid());
  getIt.registerLazySingleton<DeviceInfoPlugin>(() => DeviceInfoPlugin());
}