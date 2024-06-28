import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:todo_list_yandex_school_2024/core/logger.dart';
import 'package:todo_list_yandex_school_2024/features/main_screen/presentation/pages/main_screen.dart';

void main() {
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    logger.e("PlatformDispatcher \n $error \n $stackTrace \n");
    return true;
  };
  FlutterError.onError = (FlutterErrorDetails details) {
    logger.e("FlutterError \n ${details.exception} \n ${details.stack} \n");
  };
  runZonedGuarded(
    () => runApp(const MainApp()),
    (error, stackTrace) => logger.e("$error \n $stackTrace \n"),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: "ToDo Space",
        debugShowCheckedModeBanner: false,
        home: MainPage());
  }
}
