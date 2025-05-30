class Habit {
  final String id, name, description;
  bool completed, isEnabled;
  String start, end;

  Habit({
    required this.id,
    required this.name,
    required this.description,
    this.start = '',
    this.end = '',
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
    );
  }
}

class SmallHabit {
  final String id, name, description;
  bool pause;

  SmallHabit({
    required this.id,
    required this.name,
    required this.description,
    this.pause = false,
  });
}

class LargeHabit {
  final String id, name, description;
  int streak, missed, toggled;
  bool pause;
  String start, end;
  Map<String, Map<String, String>> schedule;
  List<String> achievements = [];

  LargeHabit({
    required this.id,
    this.name = '',
    this.description = '',
    this.start = '',
    this.pause = false,
    this.end = '',
    this.missed = 0,
    this.schedule = const {},
    this.toggled = 0,
    this.streak = 0,
  });
}
