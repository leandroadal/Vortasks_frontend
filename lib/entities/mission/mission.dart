import 'package:flutter_test_application/entities/tasks/task.dart';

class Mission {
  final String id;
  final String title;
  final String? description;
  final Status status;
  final int? xp;
  final int? coins;
  final Type type;
  final int? repetition;
  final DateTime? reminder;
  final int? skillIncrease;
  final int? skillDecrease;
  final DateTime? startDate;
  final DateTime? endDate;
  final TaskTheme theme;
  final Difficulty? difficulty;

  Mission({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    this.xp,
    this.coins,
    required this.type,
    this.repetition,
    this.reminder,
    this.skillIncrease,
    this.skillDecrease,
    this.startDate,
    this.endDate,
    required this.theme,
    this.difficulty,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.toString().split('.').last,
      'xp': xp,
      'coins': coins,
      'type': type.toString().split('.').last,
      'repetition': repetition,
      'reminder': reminder?.toIso8601String(),
      'skillIncrease': skillIncrease,
      'skillDecrease': skillDecrease,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'theme': theme.toString().split('.').last,
      'difficulty': difficulty?.toString().split('.').last,
    };
  }

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: _getStatusFromString(json['status']),
      xp: json['xp'],
      coins: json['coins'],
      type: _getTypeFromString(json['type']),
      repetition: json['repetition'],
      reminder:
          json['reminder'] != null ? DateTime.parse(json['reminder']) : null,
      skillIncrease: json['skillIncrease'],
      skillDecrease: json['skillDecrease'],
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      theme: _getThemeFromString(json['theme']),
      difficulty: json['difficulty'] != null
          ? _getDifficultyFromString(json['difficulty'])
          : null,
    );
  }

  static Status _getStatusFromString(String status) {
    return Status.values.firstWhere(
      (element) => element.toString().split('.').last == status,
      orElse: () => Status.inProgress,
    );
  }

  static Type _getTypeFromString(String type) {
    return Type.values.firstWhere(
      (element) => element.toString().split('.').last == type,
      orElse: () => Type.leisure,
    );
  }

  static TaskTheme _getThemeFromString(String theme) {
    return TaskTheme.values.firstWhere(
      (element) => element.toString().split('.').last == theme,
      orElse: () => TaskTheme.productivity,
    );
  }

  static Difficulty? _getDifficultyFromString(String? difficulty) {
    if (difficulty != null) {
      return Difficulty.values.firstWhere(
        (element) => element.toString().split('.').last == difficulty,
        orElse: () => Difficulty.easy,
      );
    }
    return null;
  }
}
