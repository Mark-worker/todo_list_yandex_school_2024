import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_yandex_school_2024/data/models/task_model.dart';
import 'package:todo_list_yandex_school_2024/domain/i_task_repository.dart';
import 'package:todo_list_yandex_school_2024/domain/todo_list_bloc/task_list_events.dart';
import 'package:todo_list_yandex_school_2024/domain/todo_list_bloc/task_list_states.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final ITaskRepository taskRepository;

  TaskListBloc(this.taskRepository) : super(EmptyState()) {
    on<FetchDataEvent>((event, emit) => _fetchData(emit));
    on<UpdateTaskEvent>((event, emit) => _updateTask(event, emit));
    on<AddTaskEvent>((event, emit) => _addTask(event, emit));
    on<DeleteTaskEvent>((event, emit) => _deleteTask(event, emit));
  }

  void _fetchData(Emitter<TaskListState> emit) async {
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

  void _updateTask(UpdateTaskEvent event, Emitter<TaskListState> emit) async {
    print("started to update task");
    final TaskModel task = event.task;
    final TaskModel changedTask = await taskRepository.changeTask(task);
    print("changed task");
    final List<TaskModel> updatedTasks = (state as LoadedState)
        .listOfTasks
        .map((task) => task.id == changedTask.id ? changedTask : task)
        .toList();
    print("created updated list of tasks");
    emit(LoadedState(updatedTasks));
    print("emitted state");
  }

  void _addTask(AddTaskEvent event, Emitter<TaskListState> emit) async {
    final TaskModel task = event.task;
    final TaskModel addedTask = await taskRepository.addTask(task);
    final List<TaskModel> updatedTasks = (state as LoadedState).listOfTasks
      ..add(addedTask);
    emit(LoadedState(updatedTasks));
  }

  void _deleteTask(DeleteTaskEvent event, Emitter<TaskListState> emit) async {
    final TaskModel task = event.task;
    final TaskModel deletedTask = await taskRepository.deleteTask(task.id);
    final updatedTasks = (state as LoadedState)
        .listOfTasks
        .where((t) => t.id != deletedTask.id)
        .toList();
    emit(LoadedState(updatedTasks));
  }
}
