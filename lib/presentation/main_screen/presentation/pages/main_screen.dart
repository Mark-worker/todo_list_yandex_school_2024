import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_yandex_school_2024/data/models/task_model.dart';
import 'package:todo_list_yandex_school_2024/domain/main_page_data_provider.dart';
import 'package:todo_list_yandex_school_2024/domain/page_state.dart';
import 'package:todo_list_yandex_school_2024/domain/use_cases/i_use_cases.dart';
import 'package:todo_list_yandex_school_2024/domain/use_cases/use_cases.dart';
import 'package:todo_list_yandex_school_2024/presentation/edit_task_screen/edit_task_screen.dart';
import 'package:todo_list_yandex_school_2024/presentation/main_screen/presentation/widgets/checkbox_line.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  late Future<List<TaskModel>> tasks;
  late UseCases useCases;

  // @override
  // void initState() {
  //   super.initState();
  //   useCases = context.read<UseCases>();
  //   tasks = useCases.getAllTasks();
  // }

  bool showUncompletedTasks = false;
  late int numOfCheckedBoxes;
  late List<TaskModel> listOfShowedTasks;
  late List<TaskModel> listOfTasks;

  void _updateTaskList() {
    numOfCheckedBoxes = [
      for (TaskModel task in listOfTasks) task.isDone ? 1 : 0
    ].reduce((a, b) => a + b);
    listOfShowedTasks = showUncompletedTasks
        ? listOfTasks.where((task) => task.isDone == false).toList()
        : listOfTasks;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainPageDataProvider>(
        builder: (context, dataProvider, child) {
      return Scaffold(
        backgroundColor: const Color(0xfff7f6f2),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              TaskModel? taskToAdd = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditTaskPage()));
              if (taskToAdd != null) {
                dataProvider.createTask(taskToAdd);
              }
            },
            backgroundColor: Colors.blue,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            )),
        body: Consumer<MainPageDataProvider>(
            builder: (context, dataProvider, child) {
          if (dataProvider.state is EmptyState) {
            dataProvider.fetchData();            return Center(child: CircularProgressIndicator());
          } else if (dataProvider.state is LoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (dataProvider.state is LoadedState &&
              dataProvider.listOfTasks.isEmpty) {
            return Center(child: Text("No tasks available"));
          } else if (dataProvider.listOfTasks.isNotEmpty) {
            listOfTasks = dataProvider.listOfTasks;
            showUncompletedTasks = dataProvider.showUncompletedTasks;
            _updateTaskList();
            return CustomScrollView(slivers: [
              const SliverAppBar(
                  backgroundColor: Color(0xfff7f6f2),
                  pinned: true,
                  snap: false,
                  floating: true,
                  expandedHeight: 140,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      "Мои дела",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  )),
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.18,
                        ),
                        Text(
                          "Выполнено - $numOfCheckedBoxes",
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () =>
                                dataProvider.changeVisibilityOfCompletedTasks,
                            icon: Icon(
                              (showUncompletedTasks
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              color: Colors.blue,
                            )),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.04,
                        )
                      ],
                    )
                  ],
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      color: Colors.white),
                  child: Column(
                    children: [
                      ListView.builder(
                        padding: const EdgeInsets.all(1),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          TaskModel task = listOfShowedTasks[index];
                          return _DismissibleTask(task, index, dataProvider);
                        },
                        itemCount: listOfShowedTasks.length,
                      ),
                      InkWell(
                        onTap: () async {
                          TaskModel? taskToAdd = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const EditTaskPage()));
                          if (taskToAdd != null) {
                            dataProvider.createTask(taskToAdd);
                          }
                        },
                        child: Row(
                          children: [
                            const Expanded(flex: 1, child: SizedBox()),
                            Expanded(
                              flex: 7,
                              child: Container(
                                height: 30,
                                margin: const EdgeInsets.all(8),
                                child: const Text(
                                  "Новое...",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                )
              ]))
            ]);
          } else {
            return Placeholder();
          }
        }),
      );
    });
  }

  Widget _DismissibleTask(
      TaskModel task, int index, MainPageDataProvider dataProvider) {
    return Dismissible(
        key: ValueKey(task.id),
        confirmDismiss: (direction) {
          if (direction == DismissDirection.startToEnd) {
            dataProvider.completeTask(task);

            return Future.value(false);
          }
          return Future.value(true);
        },
        onDismissed: (DismissDirection direction) {
          if (direction == DismissDirection.endToStart) {
            dataProvider.deleteTaskBySwipe(task.id);
          } else {
            dataProvider.completeTask(task);
          }
        },
        background: Container(
            color: Colors.green,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Icon(
                    Icons.check,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ],
            )),
        secondaryBackground: Container(
          color: Colors.red,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Icon(
                  Icons.delete,
                  size: 30,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
        child: CheckboxLine(
            task: task,
            onChanged: (bool? value) {
              dataProvider.completeTask(task);
            }));
  }
}
