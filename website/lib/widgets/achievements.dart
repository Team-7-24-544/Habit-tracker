import 'package:flutter/material.dart';
import '../models/achievement.dart';

class Achievements extends StatelessWidget {
  const Achievements({super.key});

  static final List<Achievement> achievements = [
    Achievement(
      id: '1',
      title: 'Бегун недели',
      description: 'Вы бегаете уже 10 дней подряд! Потрясающая дисциплина! 🏃',
      iconName: 'trophy',
      emoji: '🌟',
    ),
    Achievement(
      id: '2',
      title: 'Водохлеб',
      description: 'За время привыкания вы выпили уже тонну воды! Супер забота о здоровье!',
      iconName: 'droplet',
      emoji: '🎉',
    ),
    Achievement(
      id: '3',
      title: 'Мастер медитации',
      description: 'Целый месяц ежедневной медитации! Ваш разум становится сильнее! 🧘',
      iconName: 'medal',
      emoji: '✨',
    ),
  ];

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'trophy':
        return Icons.emoji_events;
      case 'droplet':
        return Icons.water_drop;
      case 'medal':
        return Icons.military_tech;
      default:
        return Icons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo.shade50,
            Colors.purple.shade50,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text(
                  'Последние достижения',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Text('🏆', style: TextStyle(fontSize: 24)),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: achievements.length,
                itemBuilder: (context, index) {
                  final achievement = achievements[index];
                  return Container(
                    width: 280,
                    margin: const EdgeInsets.only(right: 16),
                    child: Card(
                      color: Colors.white.withOpacity(0.9),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _getIconData(achievement.iconName),
                                size: 24,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          achievement.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(achievement.emoji),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    achievement.description,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}