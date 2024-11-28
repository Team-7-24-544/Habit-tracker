import 'package:flutter/material.dart';
import 'package:website/pages/template_page.dart';
import '../widgets/nav_button.dart';
import '../widgets/upcoming_achievements_list.dart';
import '../widgets/achievements.dart';

class AchievementsPage extends TemplatePage {
  final String title = 'Achievements Page';
  final NavigationOptions page = NavigationOptions.achievements;

  const AchievementsPage({super.key});

  @override
  Widget getMainArea() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: UpcomingAchievementsList(),
            ),
            const SizedBox(height: 16),
            const Expanded(
              flex: 1,
              child: Achievements(),
            ),
          ],
        ),
      ),
    );
  }
}
