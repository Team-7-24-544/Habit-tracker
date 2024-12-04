import 'package:flutter/material.dart';
import 'package:website/pages/template_page.dart';
import '../widgets/achievements.dart';
import '../widgets/emotion_selector.dart';
import '../widgets/calendar_of_emotions.dart';
import '../widgets/nav_button.dart';

class HomePage extends TemplatePage {
  final String title = 'Home Page';
  final NavigationOptions page = NavigationOptions.home;
  final EmotionCalendarController _controller = EmotionCalendarController();

  HomePage({super.key});

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              width: constraints.maxWidth,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          EmotionCalendar(
                            key: _controller.calendarKey,
                            emotions: emotions,
                            controller: _controller,
                          ),
                          const SizedBox(height: 24),
                          EmojiSelector(
                            onEmotionSelected: _controller.setEmoji,
                          ),
                          const SizedBox(height: 24),
                          const Achievements(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),
                    // const Flexible(
                    //   flex: 3,
                    //   child: HabitChecklist(),
                    // ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
