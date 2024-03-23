class Achievement {
  final String id;
  final String title;
  final String description;
  final int xp;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.xp,
  });

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'description': description, 'xp': xp};
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      xp: json['xp'],
    );
  }
}
