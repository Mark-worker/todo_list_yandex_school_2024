import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:integration_test/integration_test.dart";
import "package:todo_list_yandex_school_2024/main.dart"
    as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Создание задачи и присвоение ей приоритета",
      (WidgetTester tester) async {
    // Запуск приложения
    app.main();
    await tester.pumpAndSettle();

    // Ожидание загрузки данных
    await Future.delayed(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Нажатие на FloatingActionButton для создания новой задачи
    final fabFinder = find.byType(FloatingActionButton);
    expect(fabFinder, findsOneWidget);
    await tester.tap(fabFinder);
    await tester.pumpAndSettle();

    // Ввод текста задачи "Помыть посуду"
    final taskTextFieldFinder = find.byType(TextField);
    expect(taskTextFieldFinder, findsOneWidget);
    await tester.enterText(taskTextFieldFinder, "Go to sleep");
    await tester.pumpAndSettle();

    // Выбор приоритета задачи "high"
    final priorityButtonFinder = find.text("Нет");
    expect(priorityButtonFinder, findsOneWidget);
    await tester.tap(priorityButtonFinder);
    await tester.pumpAndSettle();

    final highPriorityFinder = find.text("!! Высокий");
    expect(highPriorityFinder, findsOneWidget);
    await tester.tap(highPriorityFinder);
    await tester.pumpAndSettle();

    // Сохранение задачи
    final saveButtonFinder = find.text("СОХРАНИТЬ");
    expect(saveButtonFinder, findsOneWidget);
    await tester.tap(saveButtonFinder);
    await tester.pumpAndSettle();

    await Future.delayed(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    // Проверка, что задача была добавлена в список
    final newTaskFinder = find.text("Go to sleep");
    expect(newTaskFinder, findsOneWidget);
  });
}
