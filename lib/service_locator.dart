import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_list_yandex_school_2024/feature/data/datasources/local_data_source.dart';
import 'package:todo_list_yandex_school_2024/feature/data/datasources/remote_data_source.dart';
import 'package:todo_list_yandex_school_2024/feature/data/task_repository.dart';
import 'package:uuid/uuid.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Register data sources
  getIt.registerLazySingleton<LocalDataSource>(() => LocalDataSource());
  getIt.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSource(getIt<Dio>()));

  // Register repository
  getIt.registerLazySingleton<TaskRepository>(() =>
      TaskRepository(getIt<LocalDataSource>(), getIt<RemoteDataSource>()));

  //Register external
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<Uuid>(() => const Uuid());
  getIt.registerLazySingleton<DeviceInfoPlugin>(() => DeviceInfoPlugin());
}
