class CheckInDays {
  String id;
  int days;
  int month;

  CheckInDays({
    required this.id,
    required this.days,
    required this.month,
  });

  factory CheckInDays.fromJson(Map<String, dynamic> json) {
    return CheckInDays(
      id: json['id'],
      days: json['days'],
      month: json['month'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'days': days,
      'month': month,
    };
  }
}
