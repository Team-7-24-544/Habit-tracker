import 'package:flutter/material.dart';

import '../../models/MetaInfo.dart';
import '../../models/achievement.dart';
import '../../services/api_manager.dart';
import '../../services/api_query.dart';
import '../../services/logger.dart';
import '../home_widgets/last_achievement_item.dart';

class Achievements extends StatefulWidget {
  const Achievements({super.key});

  @override
  State<Achievements> createState() => _AchievementsState();
}

class _AchievementsState extends State<Achievements> {
  List<Achievement> _achievements = [];
  final List<Widget> achievementWidgets = [];

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    ApiManager apiManager = MetaInfo.getApiManager();
    ApiQuery query =
        ApiQueryBuilder().path(QueryPaths.getLastAchievements).build();
    ApiResponse response = await apiManager.get(query);
    handleApiError(response: response, context: context);
    if (response.success && response.body.keys.contains('achievements')) {
      _achievements = [];
      try {
        for (Map<String, dynamic> item in response.body['achievements']) {
          if (item.containsKey('name') && item.containsKey('description')) {
            _achievements.add(Achievement(
                title: item['name'], description: item['description']));
          }
        }
      } catch (e) {
        showErrorToUser(context, 500, "Некорректный ответ сервера");
        logError(500, "Некорректный ответ сервера", response.body);
      }
      setState(() {
        for (var achievement in _achievements) {
          achievementWidgets.add(AchievementItem(achievement: achievement));
          achievementWidgets.add(const SizedBox(height: 16));
        }
      });
    } else if (response.success) {
      showErrorToUser(context, 500, "Некорректный ответ сервера");
      logError(500, "Некорректный ответ сервера", response.body);
    }
  }

  void addNewAchievement(Achievement achievement) {
    // Заглушка для добавления нового достижения
    setState(() {
      _achievements.add(achievement);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            FittedBox(
              child: Row(
                children: [
                  Text(
                    'Все достижения',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('🏆', style: TextStyle(fontSize: 24)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: achievementWidgets,
            ),
          ],
        ),
      ),
    );
  }

  Widget createAchievementItem(int index) {
    return AchievementItem(
      achievement: _achievements[index],
    );
  }
}
