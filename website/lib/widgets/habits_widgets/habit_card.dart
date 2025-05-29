import 'package:flutter/material.dart';

import '../../models/habit.dart';

class HabitCard extends StatelessWidget {
  final SmallHabit habit;
  final VoidCallback onTap;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      habit.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Switch(
                    value: habit.pause,
                    onChanged: null,
                    activeColor: Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                habit.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
