import 'package:flutter/material.dart';
import 'package:todo_list/models/todos.dart';
import 'package:todo_list/repositories/todo_repository.dart';

import '../widgets/todo_list_tem.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final todoController = TextEditingController();
  final todoRepository = TodoRepository();

  List<Todo> tarefas = [];
  Todo? tarefaDeletada;
  int? tarefaDeletadaPosition;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    todoRepository.getTodoList().then((value) {
      setState(() {
        tarefas = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: todoController,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: "Adicione uma tarefa",
                            errorText: errorMessage,
                            hintText: "Ex. Estudar Flutter"),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (todoController.text.isEmpty) {
                          setState(() {
                            errorMessage = "Você precisa digitar uma tarefa";
                          });
                          return;
                        }
                        setState(() {
                          tarefas.add(Todo(
                              title: todoController.text,
                              dateTime: DateTime.now()));
                        });
                        todoController.clear();
                        errorMessage = null;
                        todoRepository.saveTodoList(tarefas);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff00d7f3),
                          padding: const EdgeInsets.all(14)),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo tarefa in tarefas)
                        TodoListItem(
                          tarefa: tarefa,
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Você possui ${tarefas.length} tarefas pendentes",
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                        onPressed: showDeleteDialog,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff00d7f3),
                            padding: const EdgeInsets.all(14)),
                        child: const Text("Limpar tudo")),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  onDelete(Todo todo) {
    tarefaDeletada = todo;
    tarefaDeletadaPosition = tarefas.indexOf(todo);

    setState(() {
      tarefas.remove(todo);
    });
    todoRepository.saveTodoList(tarefas);

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa ${todo.title} foi removida com sucesso',
          style: const TextStyle(
            color: Color(0xff060708),
          ),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: const Color(0xff00d7f3),
          onPressed: () {
            setState(() {
              tarefas.insert(tarefaDeletadaPosition!, tarefaDeletada!);
            });
            todoRepository.saveTodoList(tarefas);
          },
        ),
      ),
    );
  }

  showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Limpar tudo?"),
        content: const Text("Você tem certeza?"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                  foregroundColor: const Color(0xff00d7f3)),
              child: const Text("Cancelar")),
          TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () {
                Navigator.of(context).pop();
                deleteAll();
              },
              child: const Text("Limpar tudo")),
        ],
      ),
    );
  }

  deleteAll() {
    setState(() {
      tarefas.clear();
    });
    todoRepository.saveTodoList(tarefas);
  }
}
