class Habit {
  final String id, name, description;
  bool completed, isEnabled;
  String start, end;
  double progress;
  Map<String, List<String>> schedule;

  Habit({
    required this.id,
    required this.name,
    required this.description,
    required this.start,
    required this.end,
    this.completed = false,
    this.isEnabled = false,
    this.progress = 0.0,
    this.schedule = const {},
  });

  Habit copyWith({
    String? id,
    String? name,
    String? description,
    String? start,
    String? end,
    bool? completed,
    bool? isEnabled,
    double? progress,
    Map<String, List<String>>? schedule,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      start: start ?? this.start,
      end: end ?? this.end,
      completed: completed ?? this.completed,
      isEnabled: isEnabled ?? this.isEnabled,
      progress: progress ?? this.progress,
      schedule: schedule ?? this.schedule,
    );
  }
}