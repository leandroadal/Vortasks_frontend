import 'package:flutter/material.dart';
import 'package:flutter_test_application/entities/tasks/task.dart';

class MyTasks extends StatefulWidget {
  const MyTasks({super.key, required this.tasks, required this.updateXp});

  final List<Task> tasks;
  final Function(Task) updateXp;

  @override
  State<MyTasks> createState() => _MyTasksState();
}

class _MyTasksState extends State<MyTasks> {
  //final int _xp = 100;
  //final int _coins = 10;

  List<Task> getSortedTasks() {
    final today = DateTime.now();
    final filteredTasks = widget.tasks
        .where((task) =>
            task.endDate.isAfter(today) && task.status == Status.inProgress)
        .toList();

    // Ordenar tarefas por proximidade da data de término
    filteredTasks.sort((a, b) =>
        a.endDate.difference(today).compareTo(b.endDate.difference(today)));

    // Limitar a 6 tarefas
    return filteredTasks.length <= 6
        ? filteredTasks
        : filteredTasks.sublist(0, 6);
  }

  @override
  Widget build(BuildContext context) {
    final sortedTasks = getSortedTasks();

    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          shrinkWrap: true,
          children: sortedTasks.map((task) {
            Color taskColor;
            if (task.type == Type.productivity) {
              taskColor =
                  const Color(0xFF614eff); // Cor para tarefas de produtividade
            } else if (task.type == Type.leisure) {
              taskColor = const Color(0xFF9735fe); // Cor para tarefas de lazer
            } else {
              taskColor = Colors.transparent;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: taskColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListTile(
                  leading: const Icon(Icons.task),
                  title: Text(
                    task.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          task.status = Status.failed;
                          setState(() {});
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () {
                          task.status = Status.completed;
                          task.finish = DateTime.now().toUtc();
                          widget.updateXp(task);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
