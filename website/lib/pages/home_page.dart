import 'package:flutter/material.dart';
import 'package:website/pages/template_page.dart';
import 'package:website/services/api_manager.dart';
import '../widgets/home_page_widgets/emotion_selector.dart';
import '../widgets/home_page_widgets/calendar_of_emotions.dart';
import '../widgets/habit_checklist.dart';
import '../widgets/nav_button.dart';

class HomePage extends TemplatePage {
  final String title = 'Home Page';
  final NavigationOptions page = NavigationOptions.home;
  final EmotionCalendarController _controller = EmotionCalendarController();

  HomePage(ApiManager apiManager, {super.key}) : super(apiManager: apiManager);

  @override
  Widget getMainArea() {
    final Map<DateTime, String> emotions = {
      DateTime(2024, 11, 11): '😊',
      DateTime(2024, 11, 22): '😢',
      DateTime(2024, 11, 13): '😡',
      DateTime(2024, 11, 14): '🥳',
      DateTime(2024, 11, 15): '😴',
    };

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        // main area //////////////// {
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  EmotionCalendar(
                      key: _controller.calendarKey,
                      emotions: emotions,
                      controller: _controller),
                  const SizedBox(height: 24),
                  EmojiSelector(onEmotionSelected: _controller.setEmoji),
                  const SizedBox(height: 24),
                  // const LastAchievements(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
            const SizedBox(width: 32),
            Flexible(
              flex: 2,
              child: HabitChecklist(),
            ),
          ],
        ),
        //  } //////////////// main area
      ),
    );
  }
}
