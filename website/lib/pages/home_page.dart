import 'package:flutter/material.dart';
import '../widgets/achievements.dart';
import '../widgets/nav_button.dart';
import '../widgets/habit_checklist.dart';
import '../widgets/calendar_of_emotions.dart';

class HomePage extends StatelessWidget {
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
      title: 'Emotion Calendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Row(
          children: [
            // Left navigation column
            Container(
              width: 80,
              color: Colors.blue.shade900,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  NavButton(
                    icon: 'web/icons/home.png',
                    label: 'Home',
                    isSelected: true,
                  ),
                  NavButton(
                    icon: 'web/icons/habits.png',
                    label: 'Habits',
                  ),
                  NavButton(
                    icon: 'web/icons/add.png',
                    label: 'New habit',
                  ),
                  NavButton(
                    icon: 'web/icons/people.png',
                    label: 'Groups',
                  ),
                  NavButton(
                    icon: 'web/icons/achievement.png',
                    label: 'Achievements',
                  ),
                  NavButton(
                    icon: 'web/icons/profile.png',
                    label: 'User',
                  ),
                  NavButton(
                    icon: 'web/icons/setting.png',
                    label: 'Settings',
                  ),
                ],
              ),
            ),
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
                          // Достижения внизу левой части
                          const Achievements(),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    // Правая часть (1/3 экрана)
                    const SizedBox(width: 32),
                    const Expanded(
                      child: HabitChecklist(),
                    ),
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
