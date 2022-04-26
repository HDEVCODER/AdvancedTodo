import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hivetodo/cubit/cubit.dart';
import 'package:hivetodo/cubit/states.dart';
import 'package:hivetodo/model/todo_model.dart';
import 'package:hivetodo/screens/all_todos_screen.dart';
import 'package:hivetodo/screens/archives_screen.dart';
import 'package:hivetodo/screens/done_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final List<Widget> list = [
    const AllTodosScreen(),
    const DoneScreen(),
    const ArchivesScreen(),
  ];
  final List<String> title = [
    "AllTodos",
    "Done",
    "Archives",
  ];
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = TodoCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(title[cubit.currentIndex]),
            ),
            body: list[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.setBottomIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.book),
                  label: 'Archived',
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text(
                        'Todo Details'), // To display the title it is optional
                    content: BlocBuilder<TodoCubit, TodoStates>(
                        builder: (context, state) {
                      return Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: cubit.titleController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Title',
                                hintText: 'Enter Title',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'hey bro dont leave it empty';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            TextFormField(
                              controller: cubit.descriptionController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Discription',
                                hintText: 'Enter Discription',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'hey bro';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    maximumSize: Size.infinite),
                                onPressed: () {
                                  cubit.setDate(context);
                                },
                                icon: const Icon(Icons.date_range),
                                label: Text(
                                  // Formatted Date
                                  DateFormat.yMMMEd()

                                      // displaying formatted date
                                      .format(cubit.initalDate),
                                )),
                          ],
                        ),
                      );
                    }),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            cubit.clearController();
                          },
                          child: const Text('Cancle')),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton.icon(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              cubit.addTodo(TodoModel(
                                title: cubit.titleController.text,
                                description: cubit.descriptionController.text,
                                date: cubit.initalDate,
                                isDone: false,
                                isArchived: false,
                              ));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content:
                                    Text('${cubit.titleController.text} added'),
                                backgroundColor: Colors.green,
                              ));
                              Navigator.pop(context);

                              cubit.clearController();
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add')),
                    ],
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
          );
        });
  }
}
