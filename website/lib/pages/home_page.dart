import 'package:flutter/material.dart';
import '../widgets/achievements.dart';
import '../widgets/navigate_bar.dart';
import '../widgets/habit_checklist.dart';
import '../widgets/calendar_of_emotions.dart';

class HomePage extends StatelessWidget {
  final String title = 'Home Page';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<DateTime, String> emotions = {
      DateTime(2024, 11, 11): '😊',
      DateTime(2024, 11, 22): '😢',
      DateTime(2024, 11, 13): '😡',
      DateTime(2024, 11, 14): '🥳',
      DateTime(2024, 11, 15): '😴',
    };

    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Row(
          children: [
            // Left navigation column
            NavigateBar(),
            // Main content area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Левая часть (2/3 экрана)
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
                    // Правая часть (1/3 экрана)
                    const SizedBox(width: 32),
                    const HabitChecklist(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
