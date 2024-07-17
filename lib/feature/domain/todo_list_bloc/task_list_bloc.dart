import "package:bloc_concurrency/bloc_concurrency.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:todo_list_yandex_school_2024/core/logger.dart";
import 'package:todo_list_yandex_school_2024/feature/data/models/task_model.dart';
import 'package:todo_list_yandex_school_2024/feature/domain/i_task_repository.dart';
import 'package:todo_list_yandex_school_2024/feature/domain/todo_list_bloc/task_list_events.dart';
import 'package:todo_list_yandex_school_2024/feature/domain/todo_list_bloc/task_list_states.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final ITaskRepository taskRepository;

  TaskListBloc(this.taskRepository) : super(EmptyState()) {
    on<TaskListEvent>(
      (event, emit) async {
        switch (event) {
          case FetchDataEvent():
            await _fetchData(event, emit);
          case UpdateTaskEvent():
            await _updateTask(event, emit);
          case AddTaskEvent():
            await _addTask(event, emit);
          case DeleteTaskEvent():
            await _deleteTask(event, emit);
        }
      },
      transformer: sequential(),
    );
  }

  Future<void> _fetchData(
      FetchDataEvent event, Emitter<TaskListState> emit) async {
    if (state is LoadingState) return;
    try {
      final currentState = state;
      List<TaskModel> oldTasksList = [];
      if (currentState is LoadedState) {
        oldTasksList = currentState.listOfTasks;
      }
      emit(LoadingState(oldTasksList, isFirstFetch: oldTasksList != []));
      List<TaskModel> updatedTasks = await taskRepository.getAllTasks();
      emit(LoadedState(updatedTasks));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> _updateTask(
      UpdateTaskEvent event, Emitter<TaskListState> emit) async {
    final TaskModel task = event.task;
    try {
      final TaskModel changedTask = await taskRepository
          .changeTask(task.copyWith(changedAt: DateTime.now()));
      final List<TaskModel> updatedTasks = (state as LoadedState)
          .listOfTasks
          .map((task) => task.id == changedTask.id ? changedTask : task)
          .toList();
      emit(LoadedState(updatedTasks));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> _addTask(AddTaskEvent event, Emitter<TaskListState> emit) async {
    logger.d(
        "length of list before adding a task: ${(state as LoadedState).listOfTasks.length}");
    // await Future.delayed(Duration(seconds: 5));
    logger.d(
        "length of list after 5 seconds: ${(state as LoadedState).listOfTasks.length}");
    final TaskModel task = event.task;
    try {
      await taskRepository.addTask(task);
      logger.d(
          "length of list after completing of addition a task: ${(state as LoadedState).listOfTasks.length}");
      final List<TaskModel> updatedTasks = (state as LoadedState).listOfTasks;
      // ..add(addedTask);
      logger.d("length of list after adding a task: ${updatedTasks.length}");
      emit(LoadedState(updatedTasks));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> _deleteTask(
      DeleteTaskEvent event, Emitter<TaskListState> emit) async {
    final TaskModel task = event.task;
    try {
      final TaskModel deletedTask = await taskRepository.deleteTask(task.id);
      final updatedTasks = (state as LoadedState)
          .listOfTasks
          .where((t) => t.id != deletedTask.id)
          .toList();
      emit(LoadedState(updatedTasks));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }
}
