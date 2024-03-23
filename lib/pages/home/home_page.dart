import 'package:flutter/material.dart';
import 'package:flutter_test_application/entities/achievement/achievement.dart';
import 'package:flutter_test_application/entities/backup/backup.dart';
import 'package:flutter_test_application/entities/checkin/check_in_days.dart';
import 'package:flutter_test_application/entities/goals/goals.dart';
import 'package:flutter_test_application/entities/mission/mission.dart';
import 'package:flutter_test_application/entities/skill/skill.dart';
import 'package:flutter_test_application/main.dart';
import 'package:flutter_test_application/services/level/level.dart';
import 'package:flutter_test_application/pages/home/app_bar.dart';
import 'package:flutter_test_application/pages/home/drawer.dart';
import 'package:flutter_test_application/pages/home/main_body.dart';
import 'package:flutter_test_application/pages/tasks/add_task.dart';
import 'package:flutter_test_application/entities/tasks/task.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Level level = Level();
  double _xpPercentage = 0;
  List<Task> tasks = [];
  Goals goals = Goals(id: generateUUID(), daily: 5, monthly: 5 * 30);
  CheckInDays checkInDays =
      CheckInDays(id: generateUUID(), days: 0, month: DateTime.now().month);
  List<Achievement> achievements = [];
  List<Mission> missions = [];
  List<Skill> skills = [];
  Backup? backup;

  void updateXp(Task task) {
    setState(() {
      level.addXP(task.xp); // Incrementa o XP do usuário
      calculateXpPercentage(); // Recalcula a porcentagem de XP
    });
  }

  void calculateXpPercentage() {
    setState(() {
      _xpPercentage = (level.xp / level.xpToNextLevel) * 100;
    });
  }

  void editGoals(double daily, double monthly) {
    goals.daily = daily;
    goals.monthly = monthly;
  }

  void addTask(Task newTask) {
    setState(() {
      tasks.add(newTask);
    });
  }

  Backup createBackup() {
    final Backup newBackup = Backup(
      id: generateUUID(),
      lastModified: DateTime.now().toUtc(),
      goals: goals,
      checkInDays: checkInDays,
      achievements: achievements,
      tasks: tasks,
      missions: missions,
      skills: skills,
    );
    setState(() {
      backup = newBackup;
    });
    return backup!;
  }

  void updateBackup(Backup? value) {
    setState(() {
      backup = value;
    });
  }

  @override
  void initState() {
    super.initState();
    calculateXpPercentage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3100a7), // Color(0xFF3100a7)
      appBar: MyAppBar(
        title: widget.title,
        tasks: tasks,
        createBackup: createBackup,
        backup: backup,
        updateBackup: updateBackup,
      ),
      drawer: const MyDrawer(),
      body: MainBody(
        xpPercentage: _xpPercentage,
        level: level,
        tasks: tasks,
        updateXp: updateXp,
        goals: goals,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar para a página de amigos
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddTaskPage(tasks: tasks, addTask: addTask)),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
