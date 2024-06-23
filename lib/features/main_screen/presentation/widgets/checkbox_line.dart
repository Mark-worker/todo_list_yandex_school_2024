import 'package:flutter/material.dart';
import 'package:todo_list_yandex_school_2024/features/models/task_model.dart';

import '../../../edit_task_screen/edit_task_page.dart';

class CheckboxLine extends StatelessWidget {
  final TaskModel task;
  final ValueChanged<bool?> onChanged;

  const CheckboxLine({super.key, required this.task, required this.onChanged});

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
                side: MaterialStateBorderSide.resolveWith(
                  (states) => BorderSide(
                      width: 2.0,
                      color: task.isDone
                          ? Colors.green
                          : task.priority != Priority.high
                              ? Colors.grey
                              : Colors.red),
                ),
                overlayColor: task.priority != Priority.high
                    ? MaterialStateProperty.all(Colors.white60)
                    : MaterialStateProperty.all(Colors.red),
                value: task.isDone,
                onChanged: onChanged),
          ),
          Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: task.isDone
                          ? const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.grey)
                          : const TextStyle(fontSize: 16, color: Colors.black),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (task.deadline != null)
                      const Text(
                        "Deadline",
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
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditTaskPage()));
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
