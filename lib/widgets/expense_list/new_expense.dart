import 'dart:io';

import 'package:expense_tracker/model/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  final void Function(Expense expense) addExpenseCall;
  const NewExpense({super.key, required this.addExpenseCall});

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  DateTime? selectedDate;
  Category? category;
  void _viewChoosedate() {
    final DateTime today = DateTime.now();
    final DateTime firstDay = DateTime(
      today.year - 1,
    );
    final DateTime lastDay = DateTime(today.year + 1);
    showDatePicker(
            context: context,
            initialDate: today,
            firstDate: firstDay,
            lastDate: lastDay)
        .then((value) {
      setState(() {
        selectedDate = value;
      });
    });
  }

  void _submitData(BuildContext context) {
    double? amount = double.tryParse(amountController.text);
    if (titleController.text.trim().isEmpty ||
        amount == null ||
        amount <= 0 ||
        category == null) {
      debugPrint("${titleController.text.trim().isEmpty}  ${amount == null}");
      if (Platform.isIOS) {
        showCupertinoDialog(
          context: (context),
          builder: (context) => CupertinoAlertDialog(
            title: const Text('invalid entry'),
            content: const Text("Please make sure ALL field are entered"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Okay"))
            ],
          ),
        );
        return;
      }
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('invalid entry'),
            content: const Text("Please make sure ALL field are entered"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Okay"))
            ],
          );
        },
      );
      return;
    }
    widget.addExpenseCall(Expense(
        title: titleController.text,
        amount: amount,
        date: selectedDate!,
        category: category!));
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        debugPrint('contraints : ${constraints}');
        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  16, 48, 16, 16 + MediaQuery.of(context).viewInsets.bottom),
              child: Column(children: [
                if (constraints.maxWidth >= 600) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: titleController,
                          maxLength: 50,
                          decoration:
                              const InputDecoration(label: Text('Title')),
                        ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Expanded(
                        child: TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              label: Text('Amount'), prefixText: "\$"),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  TextField(
                    controller: titleController,
                    maxLength: 50,
                    decoration: const InputDecoration(label: Text('Title')),
                  ),
                ],
                if (constraints.maxWidth >= 600) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: DropdownButton(
                            value: category,
                            items: Category.values
                                .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e.name.substring(0, 1).toUpperCase() +
                                          e.name.substring(1),
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    )))
                                .toList(),
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() {
                                category = value;
                              });
                            }),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          child: Row(
                        children: [
                          Text(selectedDate == null
                              ? "No date selected"
                              : formatter.format(selectedDate!)),
                          IconButton(
                              onPressed: _viewChoosedate,
                              icon: const Icon(Icons.calendar_month)),
                        ],
                      )),
                    ],
                  ),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              label: Text('Amount'), prefixText: "\$"),
                        ),
                      ),
                      Expanded(
                          child: Row(
                        children: [
                          Text(selectedDate == null
                              ? "No date selected"
                              : formatter.format(selectedDate!)),
                          IconButton(
                              onPressed: _viewChoosedate,
                              icon: const Icon(Icons.calendar_month)),
                        ],
                      )),
                    ],
                  ),
                ],
                if (constraints.maxWidth >= 600) ...[
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("CANCEL")),
                      ElevatedButton(
                          onPressed: () => {_submitData(context)},
                          child: const Text('Save Expense'))
                    ],
                  ),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButton(
                            value: category,
                            items: Category.values
                                .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e.name.substring(0, 1).toUpperCase() +
                                          e.name.substring(1),
                                    )))
                                .toList(),
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() {
                                category = value;
                              });
                            }),
                      ),
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("CANCEL")),
                      ElevatedButton(
                          onPressed: () => {_submitData(context)},
                          child: const Text('Save Expense'))
                    ],
                  ),
                ],
              ]),
            ),
          ),
        );
      },
    );
  }
}
