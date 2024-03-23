enum Status { inProgress, completed, failed }

enum Type { leisure, productivity }

enum TaskTheme {
  productivity,
  collaboration,
  learning,
  wellness,
  communication,
  creativity,
  health,
  organization,
  languages,
  finance,
  householdTasks,
  hobbies;
}

enum Difficulty { easy, medium, hard, veryHard }

class Task {
  String id;
  String name;
  String description;
  Status status;
  int xp;
  int coins;
  Type type;
  int repetition;
  String reminder;
  int skillIncrease;
  int skillDecrease;
  DateTime startDate;
  DateTime endDate;
  TaskTheme theme;
  Difficulty difficulty;
  DateTime? finish;

  Task(
      {required this.id,
      required this.name,
      required this.description,
      required this.status,
      required this.xp,
      required this.coins,
      required this.type,
      required this.repetition,
      required this.reminder,
      required this.skillIncrease,
      required this.skillDecrease,
      required this.startDate,
      required this.endDate,
      required this.theme,
      required this.difficulty,
      this.finish});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status.toString().split('.').last,
      'xp': xp,
      'coins': coins,
      'type': type.toString().split('.').last,
      'repetition': repetition,
      'reminder': reminder,
      'skillIncrease': skillIncrease,
      'skillDecrease': skillDecrease,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'theme': theme.toString().split('.').last,
      'difficulty': difficulty.toString().split('.').last,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: _getStatusFromString(json['status']),
      xp: json['xp'],
      coins: json['coins'],
      type: _getTypeFromString(json['type']),
      repetition: json['repetition'],
      reminder: json['reminder'],
      skillIncrease: json['skillIncrease'],
      skillDecrease: json['skillDecrease'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      theme: _getThemeFromString(json['theme']),
      difficulty: _getDifficultyFromString(json['difficulty']),
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

  static Difficulty _getDifficultyFromString(String difficulty) {
    return Difficulty.values.firstWhere(
      (element) => element.toString().split('.').last == difficulty,
      orElse: () => Difficulty.easy,
    );
  }
}
