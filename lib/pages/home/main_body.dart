import 'package:flutter/material.dart';
import 'package:flutter_test_application/entities/goals/goals.dart';
import 'package:flutter_test_application/services/level/level.dart';
import 'package:flutter_test_application/pages/home/task_list.dart';
import 'package:flutter_test_application/pages/home/xp_percentage.dart';
import 'package:flutter_test_application/entities/tasks/task.dart';

class MainBody extends StatelessWidget {
  const MainBody(
      {super.key,
      required this.xpPercentage,
      required this.level,
      required this.tasks,
      required this.updateXp,
      required this.goals});

  final double xpPercentage;
  final Level level;
  final List<Task> tasks;
  final Function(Task) updateXp;
  final Goals goals;

  @override
  Widget build(BuildContext context) {
    final dailyTasksCompleted = calculateDailyTasksCompleted();
    final monthlyTasksCompleted = calculateMonthlyTasksCompleted();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xFF614eff)),
                minimumSize:
                    MaterialStateProperty.all<Size>(const Size(170, 30)),
              ),
              child: const Text(
                "Resumo",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xFFebddff)),
                minimumSize:
                    MaterialStateProperty.all<Size>(const Size(170, 30)),
              ),
              child: const Text(
                "Estatísticas",
                style: TextStyle(color: Color(0xFF6754d6)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Container(
            padding: const EdgeInsets.all(5), // Espaçamento interno
            decoration: BoxDecoration(
              color: const Color(0xFF614eff),
              border:
                  Border.all(color: Colors.black12, width: 4), // Cor da borda
              borderRadius: BorderRadius.circular(10), // Borda arredondada
            ),
            child: Row(
              children: <Widget>[
                Image.asset(
                  'assets/images/avatar.png', //https://www.pngwing.com/pt/free-png-tluen
                  width: 100,
                  height: 100,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        const Text(
                          'Nível: ',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        Text(
                          '${level.currentLevel}',
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                        )
                      ],
                    ),
                    const Row(
                      children: [
                        Text(
                          'Moedas: ',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        Text(
                          '100',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Text(
                          'Conquistas: ',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        Text(
                          '0',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
                const Expanded(
                  child: SizedBox(), // Para ocupar o espaço restante
                ),
                MyXpChart(xpPercentage: xpPercentage, level: level),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Meta diária:',
                  style: TextStyle(fontSize: 18),
                ),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            height: 20,
                            color: Colors.grey[300],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: dailyTasksCompleted,
                                child: Container(
                                  height: 20,
                                  color: Colors.blue,
                                ),
                              ),
                              Expanded(
                                flex:
                                    (goals.daily - dailyTasksCompleted).toInt(),
                                child: Container(
                                  height: 20,
                                  color: Colors.transparent,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        '${(dailyTasksCompleted / goals.daily * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Meta mensal:',
                  style: TextStyle(fontSize: 18),
                ),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            height: 20,
                            color: Colors.grey[300],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: monthlyTasksCompleted,
                                child: Container(
                                  height: 20,
                                  color: Colors.green,
                                ),
                              ),
                              Expanded(
                                flex: (goals.monthly - monthlyTasksCompleted)
                                    .toInt(),
                                child: Container(
                                  height: 20,
                                  color: Colors.transparent,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        '${(monthlyTasksCompleted / goals.monthly * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20, top: 0, bottom: 20),
          child: Text(
            'Tarefas do dia',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        MyTasks(
          tasks: tasks,
          updateXp: updateXp,
        ),
      ],
    );
  }

  int calculateDailyTasksCompleted() {
    final today = DateTime.now();
    return tasks.where((task) => task.finish?.day == today.day).length;
  }

  int calculateMonthlyTasksCompleted() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    // Filtrar as tarefas com 'finish' não nulo e dentro do mês atual
    final completedTasks = tasks.where((task) =>
        task.finish != null &&
        task.finish!.isAfter(startOfMonth) &&
        task.finish!.isBefore(endOfMonth));

    return completedTasks.length;
  }
}
