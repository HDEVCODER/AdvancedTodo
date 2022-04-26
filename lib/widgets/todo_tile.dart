import 'package:flutter/material.dart';
import 'package:hivetodo/cubit/cubit.dart';
import 'package:hivetodo/model/todo_model.dart';
import 'package:intl/intl.dart';

class TodoTile extends StatelessWidget {
  const TodoTile({
    required this.todoModel,
    Key? key,
  }) : super(key: key);
  final TodoModel todoModel;
  @override
  Widget build(BuildContext context) {
    var cubit = TodoCubit.get(context);
    return ListTile(
      title: Row(
        children: [
          Text(todoModel.title),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.delete),
            color: Colors.red,
            onPressed: () {
              cubit.deleteTodo(todoModel);
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.amber,
            onPressed: () {
              cubit.updateTodo(TodoModel(
                title: todoModel.title,
                description: todoModel.description,
                date: todoModel.date,
                isDone: false,
                isArchived: false,
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.done),
            color: Colors.green,
            onPressed: () {
              cubit.updateTodo(TodoModel(
                title: todoModel.title,
                description: todoModel.description,
                date: todoModel.date,
                isDone: true,
                isArchived: false,
              ));
            },
          ),
          IconButton(
              onPressed: () {
                cubit.updateTodo(TodoModel(
                  title: todoModel.title,
                  description: todoModel.description,
                  date: todoModel.date,
                  isDone: false,
                  isArchived: true,
                ));
              },
              icon: const Icon(
                Icons.book,
              ))
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(todoModel.description),
            Text(
              // Formatted Date
              DateFormat.yMMMEd().format(todoModel.date),
            ),
          ],
        ),
      ),
    );
  }
}
