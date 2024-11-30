import 'package:flutter/material.dart';
import '../models/habit_template.dart';

class HabitTemplateList extends StatelessWidget {
  final List<HabitTemplate> templates = [
    HabitTemplate(
      id: '1',
      name: 'Утренняя зарядка',
      description: 'Начните день с энергичной тренировки',
      category: 'Здоровье',
      iconName: 'fitness_center',
      defaultSettings: {
        'duration': 15, // минут
        'preferredTime': 'morning',
      },
    ),
    HabitTemplate(
      id: '2',
      name: 'Чтение книг',
      description: 'Читайте каждый день для саморазвития',
      category: 'Образование',
      iconName: 'book',
      defaultSettings: {
        'pagesPerDay': 20,
        'preferredTime': 'evening',
      },
    ),
    // Добавьте другие шаблоны здесь
  ];

  final Function(HabitTemplate) onTemplateSelected;

  HabitTemplateList({
    super.key,
    required this.onTemplateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: templates.length,
      itemBuilder: (context, index) {
        final template = templates[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Icon(Icons.fitness_center),
            title: Text(template.name),
            subtitle: Text(template.description),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => onTemplateSelected(template),
          ),
        );
      },
    );
  }
}