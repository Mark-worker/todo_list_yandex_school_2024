import 'package:flutter/material.dart';
import 'package:todo_list_yandex_school_2024/data/models/task_model.dart';
import 'package:todo_list_yandex_school_2024/domain/i_task_repository.dart';
import 'package:todo_list_yandex_school_2024/domain/page_state.dart';

class MainPageDataProvider extends ChangeNotifier {
  MainPageState _state = EmptyState();
  final ITaskRepository _taskRepository;
  List<TaskModel> _listOfTasks = [];
  bool _showUncompletedTasks = true;

  MainPageDataProvider(this._taskRepository);

  List<TaskModel> get listOfTasks => _taskRepository.listOfTasks;
  // List<TaskModel> get listOfTasks => _listOfTasks;
  MainPageState get state => _state;
  bool get showUncompletedTasks => _showUncompletedTasks;
  // bool get hasError => _hasError;

  Future<void> fetchData() async {
    _state = LoadingState();
    notifyListeners();

    await _taskRepository.getAllTasks();
    _state = LoadedState(_listOfTasks);
    notifyListeners();
  }

  void changeVisibilityOfCompletedTasks() {
    _showUncompletedTasks = !_showUncompletedTasks;
    notifyListeners();
  }

  void completeTask(TaskModel task) {
    task = task.copyWith(isDone: !task.isDone);
    _taskRepository.changeTask(task);
    notifyListeners();
  }

  void deleteTaskBySwipe(String taskId) {
    _taskRepository.deleteTask(taskId);
    notifyListeners();
  }

  void createTask(TaskModel task) {
    _taskRepository.addTask(task);
    notifyListeners();
  }
}
