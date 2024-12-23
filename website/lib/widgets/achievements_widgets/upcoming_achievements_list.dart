import 'package:flutter/material.dart';
import '../../models/upcoming_achievement.dart';

class UpcomingAchievementsList extends StatelessWidget {
  final List<UpcomingAchievement> upcomingAchievements = [
    UpcomingAchievement(
      id: '1',
      title: 'Аполлон',
      description: 'Вы на верном пути! Продолжайте заниматься на турнике ещё 5 дней и станете лучше всех!',
      iconName: 'fitness',
      progress: 25,
      maxProgress: 30,
    ),
    UpcomingAchievement(
      id: '2',
      title: 'Книжный червь',
      description: 'Осталось прочитать всего 2 книги до получения звания заядлого читателя!',
      iconName: 'book',
      progress: 8,
      maxProgress: 10,
    ),
    UpcomingAchievement(
      id: '3',
      title: 'Ранняя пташка',
      description: 'Ещё 3 дня ранних подъёмов, и вы станете настоящим жаворонком!',
      iconName: 'alarm',
      progress: 7,
      maxProgress: 10,
    ),
  ];

  UpcomingAchievementsList({super.key});

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'fitness':
        return Icons.fitness_center;
      case 'book':
        return Icons.book;
      case 'alarm':
        return Icons.alarm;
      default:
        return Icons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ближайшие достижения',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              createUpcomingAchievement(0),
              createUpcomingAchievement(1),
              createUpcomingAchievement(2),
            ],
          ),
        ],
      ),
    );
  }

  Widget createUpcomingAchievement(int index) {
    final achievement = upcomingAchievements[index];
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getIconData(achievement.iconName),
                    size: 24,
                    color: Colors.blue.shade900,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        achievement.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        achievement.description,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: achievement.progress / achievement.maxProgress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 8),
            Text(
              '${achievement.progressPercentage.toStringAsFixed(0)}% выполнено',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
