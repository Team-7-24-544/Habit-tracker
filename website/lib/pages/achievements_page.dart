import 'package:flutter/material.dart';
import '../widgets/navigate_bar.dart';
import '../widgets/upcoming_achievements_list.dart';
import '../widgets/achievements.dart';

class AchievementsPage extends StatelessWidget {
  final String title = 'Достижения';

  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Верхняя часть (2/3 экрана) - ближайшие достижения
                    Expanded(
                      flex: 2, // Занимает 2/3 доступного пространства
                      child: UpcomingAchievementsList(),
                    ),
                    const SizedBox(height: 16),
                    // Нижняя часть (1/3 экрана) - полученные достижения
                    const Expanded(
                      flex: 1, // Занимает 1/3 доступного пространства
                      child: Achievements(),
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