import 'dart:async';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_yandex_school_2024/data/task_repository.dart';
import 'package:todo_list_yandex_school_2024/domain/todo_list_bloc/task_list_bloc.dart';
import 'package:todo_list_yandex_school_2024/domain/todo_list_bloc/task_list_events.dart';
import 'package:todo_list_yandex_school_2024/l10n/l10n.dart';
import "package:todo_list_yandex_school_2024/service_locator.dart";
import 'package:flutter/material.dart';
import 'package:todo_list_yandex_school_2024/core/logger.dart';
import 'package:todo_list_yandex_school_2024/presentation/main_screen/presentation/pages/main_screen.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        BlocProvider(
            create: (context) =>
                TaskListBloc(getIt<TaskRepository>())..add(FetchDataEvent())),
        Provider<Uuid>(create: (_) => getIt<Uuid>()),
        Provider<DeviceInfoPlugin>(create: (_) => getIt<DeviceInfoPlugin>()),
      ],
      child: MaterialApp(
          title: "ToDo Space",
          debugShowCheckedModeBanner: false,
          supportedLocales: L10n.all,
          locale: const Locale('ru'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          home: MainPage()),
    );
  }
}
