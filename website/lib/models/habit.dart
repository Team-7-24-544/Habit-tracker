class Habit {
  final String id;
  final String name;
  final String description;
  bool completed;

  Habit({
    required this.id,
    required this.name,
    required this.description,
    this.completed = false,
  });

  Habit copyWith({
    String? id,
    String? name,
    String? description,
    bool? completed,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }
}