import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo_list_yandex_school_2024/core/date_formatter.dart';
import 'package:todo_list_yandex_school_2024/features/models/task_model.dart';

class EditTaskPage extends StatefulWidget {
  const EditTaskPage({super.key});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  TaskPriority importanceValue = TaskPriority.none;
  bool switcherValue = false;

  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f6f2),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            )),
        actions: [
          TextButton(
              onPressed: () {},
              child: const Text(
                "СОХРАНИТЬ",
                style: TextStyle(color: Colors.blue),
              ))
        ],
        backgroundColor: const Color(0xfff7f6f2),
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
              const Text(
                "Важность",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
              PopupMenuButton(
                iconSize: 0,
                constraints: const BoxConstraints(minWidth: 200),
                initialValue: importanceValue,
                enableFeedback: false,
                itemBuilder: (BuildContext context) {
                  return TaskPriority.values.map<PopupMenuItem>((item) {
                    String value = item.toNameString;
                    return PopupMenuItem(
                        value: item,
                        child: SizedBox(
                          width: 100,
                          child: Text(value,
                              style: TextStyle(
                                  color: value != "!! Высокий"
                                      ? Colors.black
                                      : Colors.red,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14),
                              textHeightBehavior: const TextHeightBehavior(
                                  applyHeightToFirstAscent: true)),
                        ));
                  }).toList();
                },
                child: SizedBox(
                    height: 30,
                    width: double.infinity,
                    child: Text(
                      importanceValue.toNameString,
                      style: TextStyle(
                          color: importanceValue.toNameString != "!! Высокий"
                              ? Colors.grey
                              : Colors.red),
                    )),
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
                      const Text(
                        "Сделать до",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                      if (selectedDate != null)
                        Text(
                          formatDate(selectedDate!),
                          style:
                              const TextStyle(color: Colors.blue, fontSize: 14),
                        )
                    ],
                  ),
                  _DateSwitch()
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
              )
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
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
    log("User has selected date: $selectedDate");
  }

  Widget _InputCard() {
    return Card(
      margin: const EdgeInsets.all(0),
      semanticContainer: false,
      color: Colors.white,
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: const [BoxShadow(color: Colors.grey)]),
        child: const TextField(
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          minLines: 4,
          decoration: InputDecoration(
            hintText: "Что надо сделать...",
            hintStyle: TextStyle(color: Color(0x36000000)),
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
            log("User have tapped switcher. Position: $switcherValue");
          });
        });
  }

  Widget _DeleteButton() {
    return Container(
      margin: const EdgeInsets.all(4),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.delete,
            color: Colors.red,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "Удалить",
            style: TextStyle(color: Colors.red, fontSize: 16),
          )
        ],
      ),
    );
  }
}
