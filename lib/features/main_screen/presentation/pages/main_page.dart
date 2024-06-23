import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo_list_yandex_school_2024/features/edit_task_screen/edit_task_page.dart';
import 'package:todo_list_yandex_school_2024/features/main_screen/presentation/widgets/checkbox_line.dart';

import '../../../models/task_model.dart';

List<TaskModel> listOfTasks = [
  TaskModel(
      id: 0, title: "Сделать эту таску с номером 1", priority: Priority.low),
  TaskModel(
      id: 1,
      title: "Сделать эту таску с номером 2",
      priority: Priority.low,
      deadline: DateTime(2020)),
  TaskModel(
      id: 2, title: "Сделать эту таску с номером 3", priority: Priority.low),
  TaskModel(
      id: 3, title: "Сделать эту таску с номером 4", priority: Priority.medium),
  TaskModel(
      id: 4, title: "Сделать эту таску с номером 5", priority: Priority.low),
  TaskModel(
      id: 5, title: "Сделать эту таску с номером 6", priority: Priority.low),
  TaskModel(
      id: 6, title: "Сделать эту таску с номером 7", priority: Priority.high),
  TaskModel(
      id: 7, title: "Сделать эту таску с номером 8", priority: Priority.medium),
  TaskModel(
      id: 8, title: "Сделать эту таску с номером 9", priority: Priority.low),
  TaskModel(
      id: 9, title: "Сделать эту таску с номером 10", priority: Priority.low),
  TaskModel(
      id: 10,
      title:
          "Сделать эту очень большую, огроменную, пугающую и страшную таску с номером 11, чтобы показать, как переносится текст и как он обрезается в случае, если в тексте имеется больше, чем три строки",
      priority: Priority.low),
  TaskModel(
      id: 11,
      title: "Сделать эту таску с номером 12",
      priority: Priority.medium),
  TaskModel(
      id: 12, title: "Сделать эту таску с номером 13", priority: Priority.low),
  TaskModel(
      id: 13, title: "Сделать эту таску с номером 14", priority: Priority.low),
  TaskModel(
      id: 14, title: "Сделать эту таску с номером 15", priority: Priority.high),
  TaskModel(
      id: 15,
      title: "Сделать эту таску с номером 16",
      priority: Priority.medium),
];

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool showUndoneTasks = false;
  @override
  Widget build(BuildContext context) {
    int numOfCheckedBoxes = [
      for (TaskModel task in listOfTasks) task.isDone ? 1 : 0
    ].reduce((a, b) => a + b);
    List<TaskModel> listOfShowedTasks = showUndoneTasks
        ? listOfTasks.where((task) => task.isDone == false).toList()
        : listOfTasks;
    return Scaffold(
      backgroundColor: const Color(0xfff7f6f2),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const EditTaskPage()));
          },
          backgroundColor: Colors.blue,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          )),
      body: CustomScrollView(slivers: [
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
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () => setState(() {
                            showUndoneTasks = !showUndoneTasks;
                            log("showUndoneTasks: $showUndoneTasks");
                          }),
                      icon: showUndoneTasks
                          ? const Icon(
                              Icons.visibility_off,
                              color: Colors.blue,
                            )
                          : const Icon(
                              Icons.visibility,
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
                    return Dismissible(
                        key: ValueKey(task.id),
                        confirmDismiss: (direction) {
                          if (direction == DismissDirection.startToEnd) {
                            setState(() {
                              task.isDone = !(task.isDone);
                            });
                            return Future.value(false);
                          }
                          return Future.value(true);
                        },
                        onDismissed: (DismissDirection direction) {
                          if (direction == DismissDirection.endToStart) {
                            setState(() {
                              listOfTasks.removeAt(index);
                            });
                          } else {
                            setState(() {
                              task.isDone = !(task.isDone);
                            });
                          }
                        },
                        background: Container(
                            color: Colors.green,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 12.0),
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
                              setState(() {
                                task.isDone = value!;
                              });
                            }));
                  },
                  itemCount: listOfShowedTasks.length,
                ),
                InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditTaskPage())),
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
                            style: TextStyle(color: Colors.grey, fontSize: 16),
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
      ]),
    );
  }
}
