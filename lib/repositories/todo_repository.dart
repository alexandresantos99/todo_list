import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/todos.dart';

class TodoRepository {
  late SharedPreferences sharedPreferences;

  saveTodoList(List<Todo> todos) {
    final jsonString = json.encode(todos);
    sharedPreferences.setString('todo_list', jsonString);
  }

  Future<List<Todo>> getTodoList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString('todo_list') ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => Todo.fromJson(e)).toList();
  }
}
