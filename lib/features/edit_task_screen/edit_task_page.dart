import 'dart:developer';

import 'package:flutter/material.dart';

class EditTaskPage extends StatefulWidget {
  const EditTaskPage({super.key});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

List<DropdownMenuItem<String>> importanceItems = const [
  DropdownMenuItem(value: "Нет", child: Text("Нет")),
  DropdownMenuItem(value: "Низкий", child: Text("Низкий")),
  DropdownMenuItem(
      value: "!! Высокий",
      child: Text(
        "!! Высокий",
        style: TextStyle(color: Colors.red),
      )),
];

class _EditTaskPageState extends State<EditTaskPage> {
  String importanceValue = "Нет";
  bool switcherValue = false;

  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
    log("User has selected date: $selectedDate");
  }

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
              Center(
                child: Card(
                  margin: const EdgeInsets.all(0),
                  semanticContainer: false,
                  color: Colors.white,
                  elevation: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: const [BoxShadow(color: Colors.grey)]),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 150),
                      child: const IntrinsicHeight(
                        child: TextField(
                          expands: true,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: "Что надо сделать...",
                            hintStyle: TextStyle(color: Color(0x36000000)),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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
              DropdownButtonHideUnderline(
                child: DropdownButton(
                  iconSize: 0,
                  dropdownColor: Colors.white,
                  selectedItemBuilder: (BuildContext ctxt) {
                    return importanceItems.map<Widget>((item) {
                      return DropdownMenuItem(
                          value: item.value,
                          child: SizedBox(
                            width: 100,
                            child: Text("${item.value}",
                                style: TextStyle(
                                    color: item.value != "!! Высокий"
                                        ? Colors.grey
                                        : Colors.red,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                                textHeightBehavior: const TextHeightBehavior(
                                    applyHeightToFirstAscent: true)),
                          ));
                    }).toList();
                  },
                  value: importanceValue,
                  hint: Text(importanceValue),
                  items: importanceItems,
                  onChanged: (value) {
                    setState(() {
                      importanceValue = value!;
                    });
                  },
                ),
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
                          _dateToString(),
                          style:
                              const TextStyle(color: Colors.blue, fontSize: 14),
                        )
                    ],
                  ),
                  Switch(
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
                      })
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
                child: Container(
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String _dateToString() {
    return "${selectedDate!.day.toString().padLeft(2, '0')}.${selectedDate!.month.toString().padLeft(2, '0')}.${selectedDate!.year}";
  }
}
