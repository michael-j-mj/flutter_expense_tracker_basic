import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expense_list/expenses_list.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/widgets/expense_list/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _expenseList = [
    Expense(
        title: "flutter ",
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: "movies ",
        amount: 13,
        date: DateTime.now(),
        category: Category.leisure),
  ];
  void _addExpense(Expense expense) {
    setState(() {
      _expenseList.add(expense);
    });
  }

  void _addExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) {
        return NewExpense(addExpenseCall: _addExpense);
      },
    );
  }

  void _removeExpense(Expense expense) {
    int index = _expenseList.indexOf(expense);
    setState(() {
      _expenseList.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Expense ${expense.title} is removed'),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
          label: "UNDO",
          onPressed: () {
            setState(() {
              _expenseList.insert(index, expense);
            });
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Widget emptyListFiller = const Center(
      child: Text('No expense found, start adding some'),
    );
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Expense Tracker"),
        actions: [
          IconButton(onPressed: _addExpenseOverlay, icon: const Icon(Icons.add))
        ],
      ),
      body: Flex(
        direction: size.width > 600 ? Axis.horizontal : Axis.vertical,
        children: [
          const Text('the Chart'),
          Expanded(
            child: Chart(
              expenses: _expenseList,
            ),
          ),
          Expanded(
            child: _expenseList.isEmpty
                ? emptyListFiller
                : ExpenseList(
                    expenseList: _expenseList,
                    onRemove: _removeExpense,
                  ),
          ),
        ],
      ),
    );
  }
}
