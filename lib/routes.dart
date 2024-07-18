import "package:flutter/material.dart";
import "package:routemaster/routemaster.dart";
import "package:todo_list_yandex_school_2024/feature/presentation/edit_task_screen.dart";
import "package:todo_list_yandex_school_2024/feature/presentation/main_screen.dart";

final routes = RouteMap(routes: {
  "/": (_) => const MaterialPage(child: MainPage()),
  "/editing/:id": (route) =>
      MaterialPage(child: EditTaskPage(editingTaskId: route.pathParameters["id"])),
  "/creating": (_) => const MaterialPage(child: EditTaskPage()),
},);
