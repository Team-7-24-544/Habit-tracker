import 'package:flutter/material.dart';
import '../widgets/nav_button.dart';
import '../widgets/habit_checklist.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            //body: SafeArea(
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
                          const Text(
                            'Трекер привычек',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Основной контент будет здесь',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),
                    const Expanded(
                      child: HabitChecklist(),
                    ),
                  ],
                ),
              ),
          ),
          //),
        ],
      ),
    );
  }
}
