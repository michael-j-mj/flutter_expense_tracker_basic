import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/widgets/expense_list/expense_item.dart';
import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  final List<Expense> expenseList;
  final Function(Expense expense) onRemove;
  const ExpenseList(
      {super.key, required this.expenseList, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenseList.length,
      itemBuilder: (context, index) => Dismissible(
          background: Container(
            color: Theme.of(context).colorScheme.error.withOpacity(0.7),
            margin: Theme.of(context).cardTheme.margin,
          ),
          key: ValueKey(expenseList[index]),
          onDismissed: (direction) {
            onRemove(expenseList[index]);
          },
          child: ExpenseItem(expense: expenseList[index])),
    );
  }
}
