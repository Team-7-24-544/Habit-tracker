import 'package:flutter/material.dart';
import '../../models/habit.dart';

class HabitItem extends StatelessWidget {
  final Habit habit;
  final Function(String) onToggle;

  const HabitItem({
    super.key,
    required this.habit,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: IconButton(
          icon: Icon(
            habit.completed ? Icons.check_circle : Icons.circle_outlined,
            color: habit.completed ? Colors.green : Colors.grey,
          ),
          onPressed: () => onToggle(habit.id),
        ),
        title: Text(
          habit.name,
          style: TextStyle(
            decoration: habit.completed ? TextDecoration.lineThrough : null,
            color: habit.completed ? Colors.grey : Colors.grey[800],
          ),
        ),
        subtitle: Text(
          habit.description,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }
}
