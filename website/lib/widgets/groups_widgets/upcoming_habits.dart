import 'package:flutter/material.dart';

class UpcomingHabit {
  final String username;
  final String habitName;
  final String time;

  const UpcomingHabit({
    required this.username,
    required this.habitName,
    required this.time,
  });
}

class UpcomingHabits extends StatelessWidget {
  final List<UpcomingHabit> habits;

  const UpcomingHabits({
    super.key,
    required this.habits,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ближайшие привычки',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: habits.length,
              itemBuilder: (context, index) {
                final habit = habits[index];
                return _buildHabitItem(habit);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitItem(UpcomingHabit habit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            child: Text(habit.username[0].toUpperCase()),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(habit.habitName),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(habit.time),
          ),
        ],
      ),
    );
  }
}