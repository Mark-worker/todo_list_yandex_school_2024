import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:todo_list_yandex_school_2024/core/date_formatter.dart";
import "package:todo_list_yandex_school_2024/core/logger.dart";
import "package:todo_list_yandex_school_2024/feature/data/datasources/local_data_source.dart";
import "package:todo_list_yandex_school_2024/feature/data/models/task_model.dart";
import "package:todo_list_yandex_school_2024/feature/domain/todo_list_bloc/task_list_bloc.dart";
import "package:todo_list_yandex_school_2024/feature/domain/todo_list_bloc/task_list_events.dart";
import "package:todo_list_yandex_school_2024/feature/domain/todo_list_bloc/task_list_states.dart";
import "package:todo_list_yandex_school_2024/feature/presentation/edit_task_screen/edit_task_screen.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:todo_list_yandex_school_2024/service_locator.dart";
import "package:todo_list_yandex_school_2024/uikit/colors.dart";
import "package:todo_list_yandex_school_2024/uikit/styles.dart";

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
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    bloc = context.read<TaskListBloc>();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            TaskModel? taskToAdd = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => const EditTaskPage()));
            if (taskToAdd != null) {
              bloc.add(AddTaskEvent(taskToAdd));
            }
          },
          backgroundColor: theme.colorScheme.primary,
          shape: theme.floatingActionButtonTheme.shape,
          child: Icon(Icons.add, color: theme.colorScheme.onPrimary)),
      body: RefreshIndicator(
        backgroundColor: theme.colorScheme.surface,
        color: theme.colorScheme.onSurface,
        edgeOffset: 150,
        onRefresh: () async => bloc.add(FetchDataEvent(
            firstLaunch: getIt<LocalDataSource>().currentListOfTasks.isEmpty)),
        child:
            BlocBuilder<TaskListBloc, TaskListState>(builder: (context, state) {
          if (state is EmptyState || state is LoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is LoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is LoadedState && state.listOfTasks.isEmpty) {
            return SafeArea(
                child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                        child: Text(
                            AppLocalizations.of(context)!.noTasksAvailable)))
              ],
            ));
          } else if (state is LoadedState && state.listOfTasks.isNotEmpty) {
            listOfTasks = state.listOfTasks;
            _updateTaskList();
            return CustomScrollView(slivers: [
              ...CustomAppBar(),
              SliverList(
                  delegate: SliverChildListDelegate([
                Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      color: theme.colorScheme.surface),
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
          } else if (state is ErrorState) {
            logger.e(state.exception);
            return SafeArea(
                child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                        child:
                            Text(AppLocalizations.of(context)!.errorMessage)))
              ],
            ));
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
              child: Text(
                AppLocalizations.of(context)!.newTask,
                style: AppTextStyle.bodyStyle
                    .copyWith(color: theme.colorScheme.tertiary),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> CustomAppBar() {
    return [
      SliverAppBar(
          backgroundColor: theme.appBarTheme.backgroundColor,
          pinned: true,
          snap: false,
          floating: true,
          expandedHeight: 140,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              AppLocalizations.of(context)!.appBarTitle,
              style: theme.textTheme.titleLarge!.copyWith(
                fontSize: 26,
              ),
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
                  "${AppLocalizations.of(context)!.howMuchDone} - $numOfCheckedBoxes",
                  style: theme.textTheme.titleMedium!
                      .copyWith(color: theme.colorScheme.tertiary),
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
                      color: theme.colorScheme.primary,
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
        key: UniqueKey(),
        confirmDismiss: (direction) {
          if (direction == DismissDirection.startToEnd) {
            bool newIsDone = !task.isDone;
            TaskModel updatedTask = task.copyWith(isDone: newIsDone);
            setState(() {
              // print(listOfTasks);
              task = updatedTask;
              // print(listOfTasks);
            });
            bloc.add(UpdateTaskEvent(updatedTask));
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
            color: theme.colorScheme.secondary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Icon(
                    Icons.check,
                    size: 30,
                    color: theme.colorScheme.onSecondary,
                  ),
                ),
              ],
            )),
        secondaryBackground: Container(
          color: theme.colorScheme.error,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Icon(
                  Icons.delete,
                  size: 30,
                  color: theme.colorScheme.onError,
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

class CheckboxLine extends StatefulWidget {
  final TaskModel task;
  final ValueChanged<bool?> onChanged;

  CheckboxLine({super.key, required this.task, required this.onChanged});

  @override
  State<CheckboxLine> createState() => _CheckboxLineState();
}

class _CheckboxLineState extends State<CheckboxLine> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Checkbox(
                activeColor: ColorPalette.lightColorGreen,
                side: WidgetStateBorderSide.resolveWith(
                  (states) => BorderSide(
                      width: 2.0,
                      color: widget.task.isDone
                          ? ColorPalette.lightColorGreen
                          : widget.task.priority != TaskPriority.high
                              ? ColorPalette.lightColorGray
                              : ColorPalette.lightColorRed),
                ),
                overlayColor: widget.task.priority != TaskPriority.high
                    ? WidgetStateProperty.all(ColorPalette.lightColorGray)
                    : WidgetStateProperty.all(ColorPalette.lightColorRed),
                value: widget.task.isDone,
                onChanged: widget.onChanged),
          ),
          Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.task.text,
                      style: widget.task.isDone
                          ? theme.textTheme.bodyMedium!.copyWith(
                              color: theme.textTheme.bodySmall!.color,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: theme.textTheme.bodySmall!.color,
                            )
                          : theme.textTheme.bodyMedium,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.task.deadline != null)
                      Text(
                          formatDate(widget.task.deadline!,
                              AppLocalizations.of(context)!.languageCode),
                          style: theme.textTheme.bodySmall)
                  ],
                ),
              )),
          Expanded(
            flex: 1,
            child: IconButton(
                onPressed: () async {
                  TaskModel? newTask = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditTaskPage(
                                editingTask: widget.task,
                              )));
                  if (newTask != null) {
                    setState(() {
                      context
                          .read<TaskListBloc>()
                          .add(UpdateTaskEvent(newTask));
                    });
                  }
                },
                icon: Icon(
                  Icons.info_outline,
                  color: theme.iconTheme.color,
                )),
          )
        ],
      ),
    );
  }
}
