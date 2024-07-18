import "package:device_info_plus/device_info_plus.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:routemaster/routemaster.dart";
import "package:todo_list_yandex_school_2024/core/date_formatter.dart";
import "package:todo_list_yandex_school_2024/feature/data/models/task_model.dart";
import "package:todo_list_yandex_school_2024/feature/data/task_repository.dart";
import "package:todo_list_yandex_school_2024/feature/domain/todo_list_bloc/task_list_bloc.dart";
import "package:todo_list_yandex_school_2024/feature/domain/todo_list_bloc/task_list_events.dart";
import "package:todo_list_yandex_school_2024/feature/presentation/main_screen.dart";
import "package:todo_list_yandex_school_2024/service_locator.dart";
import "package:todo_list_yandex_school_2024/uikit/colors.dart";
import "package:uuid/uuid.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class EditTaskPage extends StatefulWidget {
  final String? editingTaskId;

  const EditTaskPage({super.key, this.editingTaskId});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final TextEditingController _controller = TextEditingController();

  late bool isEditing;
  late bool switcherValue;
  TaskPriority importanceValue = TaskPriority.none;
  DateTime? selectedDate;
  late ThemeData theme;
  late TaskModel? editingTask;

  @override
  void initState() {
    super.initState();
    getTaskInfo();
  }

  void getTaskInfo() {
    if (widget.editingTaskId == null) {
      editingTask = null;
    } else {
      final List<TaskModel> tasks = (getIt<TaskRepository>().listOfTasks);

      for (TaskModel task in tasks) {
        if (task.id == widget.editingTaskId) {
          editingTask = task;
        }
      }
    }

    isEditing = editingTask != null;
    _controller.text = isEditing ? editingTask!.text : "";
    switcherValue = isEditing ? editingTask!.deadline != null : false;
    importanceValue = isEditing ? editingTask!.priority : TaskPriority.none;
    selectedDate = isEditing ? editingTask!.deadline : null;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Routemaster.of(context).pop(),
          icon: Icon(
            Icons.close,
            color: theme.colorScheme.onSurface,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (_controller.text == "") return;

              if (isEditing) {
                final taskToChange = editingTask!.copyWith(
                  text: _controller.text,
                  deadline: switcherValue
                      ? selectedDate
                      : DateTime.fromMillisecondsSinceEpoch(0),
                  priority: importanceValue,
                  changedAt: DateTime.now(),
                  phoneIdentifier:
                      await _getPhoneId(context.read<DeviceInfoPlugin>()),
                );
                await Routemaster.of(context).pop();
                context.read<TaskListBloc>().add(UpdateTaskEvent(taskToChange));
              } else {
                final taskToSave = await _formTask(
                  context.read<Uuid>(),
                  context.read<DeviceInfoPlugin>(),
                );
                await Routemaster.of(context).pop();
                context.read<TaskListBloc>().add(AddTaskEvent(taskToSave));
              }
            },
            child: Text(
              AppLocalizations.of(context)!.saveButton.toUpperCase(),
              style: TextStyle(color: ColorPalette.lightColorBlue),
            ),
          ),
        ],
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: _InputCard()),
              const SizedBox(
                height: 30,
              ),
              Text(
                AppLocalizations.of(context)!.importanceTitle,
                style: theme.textTheme.bodyMedium!
                    .copyWith(fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 2,
              ),
              PopupMenuButton(
                iconSize: 0,
                constraints: const BoxConstraints(minWidth: 200),
                initialValue: importanceValue,
                enableFeedback: false,
                itemBuilder: (BuildContext context) {
                  return TaskPriority.values.map<PopupMenuItem>((item) {
                    String value = importanceToString(item);
                    return PopupMenuItem(
                      value: item,
                      child: SizedBox(
                        width: 100,
                        child: Text(
                          value,
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: value !=
                                    AppLocalizations.of(context)!.highImportance
                                ? theme.textTheme.bodyMedium!.color
                                : ColorPalette.lightColorRed,
                          ),
                          textHeightBehavior: const TextHeightBehavior(
                            applyHeightToFirstAscent: true,
                          ),
                        ),
                      ),
                    );
                  }).toList();
                },
                child: SizedBox(
                  height: 30,
                  width: double.infinity,
                  child: Text(
                    importanceToString(importanceValue),
                    style: TextStyle(
                      color: importanceToString(importanceValue) !=
                              AppLocalizations.of(context)!.highImportance
                          ? theme.textTheme.bodySmall!.color
                          : ColorPalette.lightColorRed,
                    ),
                  ),
                ),
                onSelected: (value) {
                  setState(() {
                    importanceValue = value ?? "";
                  });
                },
              ),
              const Divider(),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.doUntilTitle,
                        style: theme.textTheme.bodyMedium!
                            .copyWith(fontWeight: FontWeight.w400),
                      ),
                      if (selectedDate != null)
                        Text(
                          formatDate(
                            selectedDate!,
                            AppLocalizations.of(context)!.languageCode,
                          ),
                          style:
                              const TextStyle(color: Colors.blue, fontSize: 14),
                        ),
                    ],
                  ),
                  _DateSwitch(),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {},
                child: _DeleteButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String importanceToString(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.none:
        return AppLocalizations.of(context)!.noneImportance;
      case TaskPriority.low:
        return AppLocalizations.of(context)!.lowImportance;
      case TaskPriority.high:
        return AppLocalizations.of(context)!.highImportance;
    }
  }

  Widget _InputCard() {
    return Card(
      margin: const EdgeInsets.all(0),
      semanticContainer: false,
      color: theme.colorScheme.surface,
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: theme.colorScheme.surface,
          boxShadow: const [BoxShadow(color: ColorPalette.lightColorGray)],
        ),
        child: TextField(
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          controller: _controller,
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          minLines: 4,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.textFieldHint,
            hintStyle: theme.inputDecorationTheme.hintStyle,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _DateSwitch() {
    return Switch(
      value: switcherValue,
      onChanged: (value) async {
        if (switcherValue) {
          selectedDate = null;
        } else {
          await _selectDate(context);
        }
        setState(() {
          if (selectedDate != null) {
            switcherValue = true;
          } else {
            switcherValue = false;
          }
        });
      },
    );
  }

  Widget _DeleteButton() {
    return Container(
      margin: const EdgeInsets.all(4),
      child: InkWell(
        onTap: () async {
          if (editingTask != null) {
            await Routemaster.of(context).pop();
            context.read<TaskListBloc>().add(DeleteTaskEvent(editingTask!));
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.delete,
              color: ColorPalette.lightColorRed,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              AppLocalizations.of(context)!.deleteButton,
              style: theme.textTheme.bodyMedium!
                  .copyWith(color: ColorPalette.lightColorRed),
            ),
          ],
        ),
      ),
    );
  }

  Future<TaskModel> _formTask(Uuid uuid, DeviceInfoPlugin deviceInfo) async {
    return TaskModel(
      id: uuid.v1(),
      text: _controller.text,
      priority: importanceValue,
      isDone: false,
      createdAt: DateTime.now(),
      changedAt: DateTime.now(),
      phoneIdentifier: await _getPhoneId(deviceInfo),
      deadline: selectedDate,
    );
  }

  Future<String> _getPhoneId(DeviceInfoPlugin deviceInfo) async {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    String phoneId = androidDeviceInfo.id;
    return phoneId;
  }
}
