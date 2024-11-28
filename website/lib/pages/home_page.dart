import 'package:flutter/material.dart';
import 'package:website/pages/template_page.dart';
import '../widgets/achievements.dart';
import '../widgets/habit_checklist.dart';
import '../widgets/calendar_of_emotions.dart';
import '../widgets/nav_button.dart';

class HomePage extends TemplatePage {
  final String title = 'Home Page';
  final NavigationOptions page = NavigationOptions.home;

  const HomePage({super.key});

  @override
  Widget getMainArea() {
    final Map<DateTime, String> emotions = {
      DateTime(2024, 11, 11): '😊',
      DateTime(2024, 11, 22): '😢',
      DateTime(2024, 11, 13): '😡',
      DateTime(2024, 11, 14): '🥳',
      DateTime(2024, 11, 15): '😴',
    };
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EmotionCalendar(emotions: emotions),
                  const Spacer(),
                  const Achievements(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(width: 32),
            const HabitChecklist(),
          ],
        ),
      ),
    );
  }
}
