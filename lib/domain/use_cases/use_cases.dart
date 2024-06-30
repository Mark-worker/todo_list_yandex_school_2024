import 'package:todo_list_yandex_school_2024/data/models/task_model.dart';
import 'package:todo_list_yandex_school_2024/data/task_repository.dart';
import 'package:todo_list_yandex_school_2024/domain/use_cases/i_use_cases.dart';

class GetAllTasks implements IGetAllTasks {
  final TaskRepository repository;

  GetAllTasks(this.repository);

  @override
  Future<List<TaskModel>> call() async {
    return await repository.getAllTasks();
  }
}

class AddTask implements IAddTask {
  final TaskRepository repository;

  AddTask(this.repository);

  @override
  Future<void> call(TaskModel task) async {
    await repository.addTask(task);
  }
}

class UpdateTasks implements IUpdateTasks {
  final TaskRepository repository;

  UpdateTasks(this.repository);

  @override
  Future<void> call(List<TaskModel> tasks) async {
    await repository.updateTasks(tasks);
  }
}

class DeleteTask implements IDeleteTask {
  final TaskRepository repository;

  DeleteTask(this.repository);

  @override
  Future<void> call(String taskId) async {
    await repository.deleteTask(taskId);
  }
}

class ChangeTask implements IChangeTask {
  final TaskRepository repository;

  ChangeTask(this.repository);

  @override
  Future<void> call(TaskModel task) async {
    await repository.changeTask(task);
  }
}

class GetTask implements IGetTask {
  final TaskRepository repository;

  GetTask(this.repository);

  @override
  Future<TaskModel> call(String taskId) async {
    return await repository.getTask(taskId);
  }
}
