class Goals {
  final String id;
  final double daily;
  final double monthly;

  Goals({
    required this.id,
    required this.daily,
    required this.monthly,
  });

  set daily(double daily) {
    this.daily = daily;
  }

  set monthly(double monthly) {
    this.monthly = monthly;
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'daily': daily, 'monthly': monthly};
  }

  factory Goals.fromJson(Map<String, dynamic> json) {
    return Goals(
      id: json['id'],
      daily: json['daily'],
      monthly: json['monthly'],
    );
  }
}
