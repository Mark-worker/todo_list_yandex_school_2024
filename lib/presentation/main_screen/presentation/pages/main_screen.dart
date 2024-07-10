import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_yandex_school_2024/data/models/task_model.dart';
import 'package:todo_list_yandex_school_2024/domain/todo_list_bloc/task_list_bloc.dart';
import 'package:todo_list_yandex_school_2024/domain/todo_list_bloc/task_list_events.dart';
import 'package:todo_list_yandex_school_2024/domain/todo_list_bloc/task_list_states.dart';
import 'package:todo_list_yandex_school_2024/presentation/edit_task_screen/edit_task_screen.dart';
import 'package:todo_list_yandex_school_2024/presentation/main_screen/presentation/widgets/checkbox_line.dart';

class MainPage extends StatefulWidget {
  MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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

  late TaskListBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = context.read<TaskListBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f6f2),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            TaskModel? taskToAdd = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => const EditTaskPage()));
            if (taskToAdd != null) {
              bloc.add(AddTaskEvent(taskToAdd));
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
      body: RefreshIndicator(
        edgeOffset: 140,
        onRefresh: () async =>
            context.read<TaskListBloc>().add(FetchDataEvent()),
        child:
            BlocBuilder<TaskListBloc, TaskListState>(builder: (context, state) {
          if (state is EmptyState || state is LoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is LoadingState) {
            // if (state.isFirstFetch) {
            return Center(child: CircularProgressIndicator());
            // }
            // return TaskListBuilder();
          } else if (state is LoadedState && state.listOfTasks.isEmpty) {
            return Center(child: Text("No tasks available"));
          } else if (state is LoadedState && state.listOfTasks.isNotEmpty) {
            listOfTasks = state.listOfTasks;
            _updateTaskList();
            return CustomScrollView(slivers: [
              ...CustomAppBar(),
              SliverList(
                  delegate: SliverChildListDelegate([
                Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      color: Colors.white),
                  child: Column(
                    children: [
                      TaskListBuilder(),
                      NewTaskTile(),
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
      ),
    );
  }

  Widget TaskListBuilder() {
    return ListView.builder(
      padding: const EdgeInsets.all(1),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        TaskModel task = listOfShowedTasks[index];
        return _DismissibleTask(task, index, context);
      },
      itemCount: listOfShowedTasks.length,
    );
  }

  Widget NewTaskTile() {
    return InkWell(
      onTap: () async {
        TaskModel? taskToAdd = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => const EditTaskPage()));
        if (taskToAdd != null) {
          bloc.add(AddTaskEvent(taskToAdd));
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
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
    );
  }

  List<Widget> CustomAppBar() {
    return [
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
                          showUncompletedTasks = !showUncompletedTasks;
                        }),
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
    ];
  }

  Widget _DismissibleTask(TaskModel task, int index, BuildContext context) {
    return Dismissible(
        key: ValueKey(task.id),
        confirmDismiss: (direction) {
          if (direction == DismissDirection.startToEnd) {
            bool newIsDone = !task.isDone;
            setState(() {
              // print(listOfTasks);
              task = task.copyWith(isDone: newIsDone);
              // print(listOfTasks);
            });
            context
                .read<TaskListBloc>()
                .add(UpdateTaskEvent(task.copyWith(isDone: newIsDone)));
            return Future.value(false);
          }
          return Future.value(true);
        },
        onDismissed: (DismissDirection direction) {
          if (direction == DismissDirection.endToStart) {
            bloc.add(DeleteTaskEvent(task));
          } else {
            bloc.add(UpdateTaskEvent(task.copyWith(isDone: !task.isDone)));
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
              bloc.add(UpdateTaskEvent(task.copyWith(isDone: !task.isDone)));
            }));
  }
}
