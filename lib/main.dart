import 'dart:async';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_yandex_school_2024/domain/use_cases/i_use_cases.dart';
import "package:todo_list_yandex_school_2024/service_locator.dart";
import 'package:flutter/material.dart';
import 'package:todo_list_yandex_school_2024/core/logger.dart';
import 'package:todo_list_yandex_school_2024/presentation/main_screen/presentation/pages/main_screen.dart';
import 'package:uuid/uuid.dart';

void main() {
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    logger.e("PlatformDispatcher \n $error \n $stackTrace \n");
    return true;
  };
  FlutterError.onError = (FlutterErrorDetails details) {
    logger.e("FlutterError \n ${details.exception} \n ${details.stack} \n");
  };
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();
      setupLocator();
      runApp(const MainApp());
    },
    (error, stackTrace) => logger.e("$error \n $stackTrace \n"),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<IGetAllTasks>(create: (_) => getIt<IGetAllTasks>()),
        Provider<IAddTask>(create: (_) => getIt<IAddTask>()),
        Provider<IUpdateTasks>(create: (_) => getIt<IUpdateTasks>()),
        Provider<IDeleteTask>(create: (_) => getIt<IDeleteTask>()),
        Provider<IChangeTask>(create: (_) => getIt<IChangeTask>()),
        Provider<IGetTask>(create: (_) => getIt<IGetTask>()),
        Provider<Uuid>(create: (_) => getIt<Uuid>()),
        Provider<DeviceInfoPlugin>(create: (_) => getIt<DeviceInfoPlugin>()),
      ],
      child: const MaterialApp(
          title: "ToDo Space",
          debugShowCheckedModeBanner: false,
          home: MainPage()),
    );
  }
}
