import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_yandex_school_2024/core/date_formatter.dart';
import 'package:todo_list_yandex_school_2024/feature/data/models/task_model.dart';
import 'package:todo_list_yandex_school_2024/feature/domain/todo_list_bloc/task_list_bloc.dart';
import 'package:todo_list_yandex_school_2024/feature/domain/todo_list_bloc/task_list_events.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../edit_task_screen/edit_task_screen.dart';

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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Checkbox(
                activeColor: Colors.green,
                side: WidgetStateBorderSide.resolveWith(
                  (states) => BorderSide(
                      width: 2.0,
                      color: widget.task.isDone
                          ? Colors.green
                          : widget.task.priority != TaskPriority.high
                              ? Colors.grey
                              : Colors.red),
                ),
                overlayColor: widget.task.priority != TaskPriority.high
                    ? WidgetStateProperty.all(Colors.white60)
                    : WidgetStateProperty.all(Colors.red),
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
                          ? const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.grey)
                          : const TextStyle(fontSize: 16, color: Colors.black),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.task.deadline != null)
                      Text(
                        formatDate(widget.task.deadline!,
                            AppLocalizations.of(context)!.languageCode),
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      )
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
                icon: const Icon(
                  Icons.info_outline,
                  color: Colors.grey,
                )),
          )
        ],
      ),
    );
  }
}
