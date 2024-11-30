class HabitTemplate {
  final String id;
  final String name;
  final String description;
  final String category;
  final String iconName;
  final Map<String, dynamic> defaultSettings;

  HabitTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.iconName,
    required this.defaultSettings,
  });
}