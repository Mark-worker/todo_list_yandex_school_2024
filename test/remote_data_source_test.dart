import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:todo_list_yandex_school_2024/feature/data/datasources/remote_data_source.dart";
import "package:todo_list_yandex_school_2024/feature/data/models/task_model.dart";
import "package:dio/dio.dart";
import "mocks.mocks.dart";

void main() {
  late RemoteDataSource remoteDataSource;
  late MockDio mockDio;
  late BaseOptions mockOptions;

  setUp(() {
    mockDio = MockDio();
    mockOptions = BaseOptions();
    when(mockDio.options).thenReturn(mockOptions);
    remoteDataSource = RemoteDataSource();
  });

  group("RemoteDataSource Tests", () {
    test("getAllTasks returns list of TaskModel", () async {
      final responsePayload = {
        "list": [
          {
            "importance": "low",
            "last_updated_by": "SE1A.220826.008",
            "text": "First task",
            "changed_at": 1720652252144,
            "created_at": 1720652252144,
            "done": false,
            "id": "c9dba720-f6e3-107b-9dd5-978ed55be80e"
          },
          {
            "importance": "important",
            "last_updated_by": "SE1A.220826.008",
            "text": "Second task",
            "changed_at": 1720663248029,
            "created_at": 1720663248029,
            "done": false,
            "id": "9217a620-5ae5-107c-b467-53d968c28cb3"
          }
        ],
        "status": "ok",
        "revision": 1
      };

      when(mockDio.get(any)).thenAnswer(
        (_) async => Response(
          data: responsePayload,
          statusCode: 200,
          requestOptions: RequestOptions(path: ""),
        ),
      );

      final tasks = await remoteDataSource.getAllTasks();

      expect(tasks, isA<List<TaskModel>>());
      expect(tasks.length, 2);
      expect(tasks[0].text, "First task");
      expect(tasks[1].text, "Second task");
    });

    test("addTask returns the added TaskModel", () async {
      final taskToAdd = TaskModel.fromMap({
        "importance": "important",
        "last_updated_by": "SE1A.220826.008",
        "text": "Third task",
        "changed_at": 1720663248029,
        "created_at": 1720663248029,
        "done": false,
        "id": "3ef1c6c0-9db1-107b-a69a-050c95ba5361"
      });

      final responsePayload = {
        "revision": 2,
        "element": taskToAdd.toMap(),
      };

      when(mockDio.post(any,
              data: anyNamed("data"), options: anyNamed("options")))
          .thenAnswer(
        (_) async => Response(
          data: responsePayload,
          statusCode: 200,
          requestOptions: RequestOptions(path: ""),
        ),
      );

      final addedTask = await remoteDataSource.addTask(taskToAdd);

      expect(addedTask, isA<TaskModel>());
      expect(addedTask.text, "Third task");
      expect(addedTask.priority, TaskPriority.high);
    });
  });
}
