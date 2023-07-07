import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../models/todos.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({super.key, required this.tarefa, required this.onDelete});

  final Todo tarefa;
  final Function(Todo) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        actionPane: const SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        secondaryActions: [
          IconSlideAction(
            color: Colors.red,
            icon: Icons.delete,
            caption: "Deletar",
            onTap: () {
              onDelete(tarefa);
            },
          )
        ],
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.circular(4),
              color: Colors.grey[200]),
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(
              DateFormat('dd/MM/yyyy - HH:mm').format(tarefa.dateTime),
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              tarefa.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ]),
        ),
      ),
    );
  }
}
