class HabitSettings {
  final String name;
  final String description;
  final String timeTable;

  HabitSettings({
    required this.name,
    required this.description,
    required this.timeTable,
    List<bool>? weekDays,
  });
}
