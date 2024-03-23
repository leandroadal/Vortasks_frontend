class Skill {
  final String id;
  final String name;
  final double? xp;
  final int? level;

  Skill({
    required this.id,
    required this.name,
    required this.xp,
    required this.level,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'xp': xp,
      'level': level,
    };
  }

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'],
      name: json['name'],
      xp: json['xp'],
      level: json['level'],
    );
  }
}
