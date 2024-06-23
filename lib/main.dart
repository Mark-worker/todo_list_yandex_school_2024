import 'package:flutter/material.dart';
import 'package:todo_list_yandex_school_2024/features/main_screen/presentation/pages/main_page.dart';

void main() {
  runApp(const MainApp());
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
