import 'package:flutter/material.dart';
import 'package:website/models/MetaInfo.dart';
import 'package:website/services/api_manager.dart';
import 'package:website/services/api_query.dart';

import '../../models/achievement.dart';
import '../../services/logger.dart';
import 'last_achievement_item.dart';

class LastAchievements extends StatefulWidget {
  const LastAchievements({super.key});

  @override
  State<LastAchievements> createState() => _AchievementsState();
}

class _AchievementsState extends State<LastAchievements> {
  List<Achievement> _achievements = [];
  final List<Widget> _achievementWidgets = [];

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
      for (var item in response.body['achievements']) {
        _achievements.add(
            Achievement(title: item['name'], description: item['description']));
      }
      setState(() {
        for (var achievement in _achievements) {
          _achievementWidgets.add(AchievementItem(achievement: achievement));
          _achievementWidgets.add(const SizedBox(height: 8));
        }
      });
    } else if (!response.body.keys.contains('achievements')) {
      showErrorToUser(context, 500, "Некорректный ответ сервера");
      logError(500, "Некорректный ответ сервера", response.body);
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
          Column(children: _achievementWidgets),
        ],
      ),
    );
  }
}
