import 'package:flutter/material.dart';
import '../../models/achievement.dart';
import 'last_achievement_item.dart';

class LastAchievements extends StatefulWidget {
  const LastAchievements({super.key});

  @override
  State<LastAchievements> createState() => _AchievementsState();
}

class _AchievementsState extends State<LastAchievements> {
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
    List<Widget> children = [];
    for (int i = 0; i < _achievements.length; i++) {
      children.add(createAchievementItem(i));
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FittedBox(
            child: Row(
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
          ),
          const SizedBox(height: 16),
          Column(children: children),
        ],
      ),
    );
  }

  Widget createAchievementItem(int index) {
    return AchievementItem(
      achievement: _achievements[index],
      getIconData: _getIconData,
    );
  }
}
