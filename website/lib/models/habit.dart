class Habit {
  final String id, name, description;
  bool completed, isEnabled;
  String start, end;

  Habit({
    required this.id,
    required this.name,
    required this.description,
    this.start = "",
    this.end = "",
    this.completed = false,
    this.isEnabled = false,
  });

  Habit copyWith({
    String? id,
    String? name,
    String? description,
    String? start,
    String? end,
    bool? completed,
    bool? isEnabled,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      start: start ?? this.start,
      end: end ?? this.end,
      completed: completed ?? this.completed,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
