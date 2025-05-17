import 'package:flutter/material.dart';

class AchievementLeaderboard extends StatelessWidget {
  final Map<String, int> userAchievements;

  const AchievementLeaderboard({
    super.key,
    required this.userAchievements,
  });

  @override
  Widget build(BuildContext context) {
    // Правильно сортируем список «на месте» и возвращаем его же
    final sortedUsers = userAchievements.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Таблица достижений',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Проходим по уже отсортированному списку
            ...sortedUsers.asMap().entries.map((entry) {
              final index = entry.key;
              final user = entry.value;
              return _buildLeaderboardItem(
                user.key,
                user.value,
                index + 1,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardItem(String username, int achievements, int position) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: _getPositionColor(position),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                position.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            username,
            style: const TextStyle(fontSize: 16),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              achievements.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPositionColor(int position) {
    switch (position) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey.shade400;
      case 3:
        return Colors.brown.shade300;
      default:
        return Colors.blue.shade300;
    }
  }
}
