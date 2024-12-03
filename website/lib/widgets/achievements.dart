import 'package:flutter/material.dart';
import '../models/achievement.dart';
import 'achievement_item.dart';

class Achievements extends StatefulWidget {
  const Achievements({super.key});

  @override
  State<Achievements> createState() => _AchievementsState();
}

class _AchievementsState extends State<Achievements> {
  List<Achievement> _achievements = [];

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  void _loadAchievements() {
    // В реальном приложении здесь будет загрузка из базы данных или API
    _achievements = [
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
    setState(() {});
  }

  void addNewAchievement(Achievement achievement) {
    // Заглушка для добавления нового достижения
    setState(() {
      _achievements.add(achievement);
    });
  }

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
                itemCount: _achievements.length,
                itemBuilder: (context, index) {
                  return AchievementItem(
                    achievement: _achievements[index],
                    getIconData: _getIconData,
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
