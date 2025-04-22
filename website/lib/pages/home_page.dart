import 'package:flutter/material.dart';
import 'package:website/pages/template_page.dart';
import '../widgets/home_widgets/emotion_selector.dart';
import '../widgets/home_widgets/calendar_of_emotions.dart';
import '../widgets/home_widgets/habit_checklist.dart';
import '../widgets/home_widgets/last_achivements.dart';
import '../widgets/navigation_widgets/nav_button.dart';

class HomePage extends TemplatePage {
  @override
  String get title => 'Home Page';

  @override
  NavigationOptions get page => NavigationOptions.home;
  final EmotionCalendarController _controller = EmotionCalendarController();

  HomePage({super.key});

  @override
  Widget getMainArea(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              EmotionCalendar(key: _controller.calendarKey, controller: _controller),
              const SizedBox(height: 24),
              EmojiSelector(onEmotionSelected: _controller.setEmoji),
              const SizedBox(height: 24),
              LastAchievements(),
              const SizedBox(height: 100),
            ],
          ),
        ),
        const SizedBox(width: 32),
        Flexible(flex: 2, child: HabitChecklist()),
      ],
    );
  }
}
