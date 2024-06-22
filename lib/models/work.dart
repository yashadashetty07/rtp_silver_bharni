class Work {
  int? id;
  String employeeName;
  String shikka;
  String category;
  double weight;
  DateTime date;
  DateTime taskAddingTime;

  Work({
    this.id,
    required this.employeeName,
    required this.shikka,
    required this.category,
    required this.weight,
    required this.date,
    required this.taskAddingTime,
  });

  // Convert a Work object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employeeName': employeeName,
      'shikka': shikka,
      'category': category,
      'weight': weight,
      'date': date.toIso8601String(), // Convert DateTime to a string
      'taskAddingTime': taskAddingTime.toIso8601String(), // Convert DateTime to a string
    };
  }

  // Convert a Map object into a Work object
  factory Work.fromMap(Map<String, dynamic> map) {
    return Work(
      id: map['id'],
      employeeName: map['employeeName'],
      shikka: map['shikka'],
      category: map['category'],
      weight: map['weight'],
      date: DateTime.parse(map['date']), // Convert string back to DateTime
      taskAddingTime: DateTime.parse(map['taskAddingTime']), // Convert string back to DateTime
    );
  }
}
