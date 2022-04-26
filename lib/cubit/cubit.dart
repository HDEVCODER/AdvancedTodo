import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hivetodo/cubit/states.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hivetodo/model/todo_model.dart'; 

class TodoCubit extends Cubit<TodoStates> {
  TodoCubit() : super(InitialAppState());

  static TodoCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  setBottomIndex(int index) {
    currentIndex = index;
    emit(SetCurrentIndexAppState());
  }

  // controllers

  var titleController = TextEditingController();
  var descriptionController = TextEditingController();

  // date time picker
  var initalDate = DateTime.now();
  setDate(BuildContext context) {
    showDatePicker(
      context: context,
      currentDate: initalDate,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    ).then((value) {
      if (value != null) {
        initalDate = value;
      }
      emit(SetDateState());
    });
  }

  List<TodoModel>? todosList = [];
  List<int>? keys = [];
  getBox() async {
    var box = await Hive.openBox<TodoModel>('todos');
    keys = [];
    keys = box.keys.cast<int>().toList();
    todosList = [];
    for (var key in keys!) {
      todosList!.add(box.get(key)!);
    }
    box.close();
    emit(GetBobState());
  }

  addTodo(TodoModel todoModel) async {
    await Hive.openBox<TodoModel>('todos')
        .then((value) => value.add(todoModel))
        .then(
          (value) => getBox(),
        );
    emit(AddTotodosListState());
  }

  updateTodo(TodoModel todoModel) async {
    await Hive.openBox<TodoModel>('todos').then((value) {
      final Map<dynamic, TodoModel> todoMap = value.toMap();
      dynamic desiredKey;
      todoMap.forEach((key, value) {
        if (value.title == todoModel.title) {
          desiredKey = key;
        }
      });
      return value.put(desiredKey, todoModel);
    }).then(
      (value) => getBox(),
    );
  }

  deleteTodo(TodoModel todoModel) async {
    await Hive.openBox<TodoModel>('todos').then((value) {
      final Map<dynamic, TodoModel> todoMap = value.toMap();
      dynamic desiredKey;
      todoMap.forEach((key, value) {
        if (value.title == todoModel.title) {
          desiredKey = key;
        }
      });
      return value.delete(desiredKey);
    }).then(
      (value) => getBox(),
    );
  }

  clearController() {
    descriptionController.clear();
    titleController.clear();
  }
}
