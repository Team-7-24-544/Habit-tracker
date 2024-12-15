import 'package:flutter/material.dart';
import 'package:website/pages/template_page.dart';
import '../widgets/nav_button.dart';
import '../widgets/upcoming_achievements_list.dart';
import '../widgets/achievements.dart';

class AchievementsPage extends TemplatePage {
  @override
  String get title => 'Achievements Page';

  @override
  NavigationOptions get page => NavigationOptions.achievements;

  const AchievementsPage({super.key});

  @override
  Widget getMainArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UpcomingAchievementsList(),
        const SizedBox(height: 16),
        Achievements(),
        const SizedBox(height: 100),
      ],
    );
  }
}
