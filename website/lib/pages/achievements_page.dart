import 'package:flutter/material.dart';
import 'package:website/pages/template_page.dart';
import '../services/api_manager.dart';
import '../widgets/nav_button.dart';
import '../widgets/upcoming_achievements_list.dart';
import '../widgets/achievements.dart';

class AchievementsPage extends TemplatePage {
  final String title = 'Achievements Page';
  final NavigationOptions page = NavigationOptions.achievements;

  const AchievementsPage(ApiManager apiManager, {super.key})
      : super(apiManager: apiManager);

  @override
  Widget getMainArea() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UpcomingAchievementsList(),
            const SizedBox(height: 16),
            Achievements(),
            const SizedBox(height: 100),
          ],
        ),
        // ),
        //),
      ),
    );
  }
}
