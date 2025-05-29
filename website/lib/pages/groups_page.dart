import 'package:flutter/material.dart';
import 'package:website/pages/template_page.dart';
import '../widgets/navigation_widgets/nav_button.dart';
import '../widgets/groups_widgets/group_header.dart';
import '../widgets/groups_widgets/achievement_leaderboard.dart';
import '../widgets/groups_widgets/recent_achievements.dart';
import '../widgets/groups_widgets/upcoming_habits.dart';
import '../widgets/groups_widgets/group_chat.dart';

class GroupsPage extends TemplatePage {
  @override
  String get title => 'Groups Page';

  @override
  NavigationOptions get page => NavigationOptions.groups;

  const GroupsPage({super.key});

  @override
  Widget getMainArea(BuildContext context) {
    // Placeholder data
    final members = ['Alex123', 'Maria_fit', 'John_doe', 'FitnessGuru'];
    
    final achievements = {
      'Alex123': 15,
      'Maria_fit': 12,
      'John_doe': 18,
      'FitnessGuru': 10,
    };

    final recentAchievements = [
      RecentAchievement(
        username: 'John_doe',
        achievementName: 'Завершено 10 тренировок подряд! 🏆',
        date: '2 часа назад',
        reactions: 3,
        hasReacted: true,
      ),
      RecentAchievement(
        username: 'Maria_fit',
        achievementName: 'Первая неделя медитации! 🧘‍♀️',
        date: '5 часов назад',
        reactions: 2,
      ),
      RecentAchievement(
        username: 'Alex123',
        achievementName: 'Месяц здорового питания! 🥗',
        date: '1 день назад',
        reactions: 4,
      ),
    ];

    final upcomingHabits = [
      UpcomingHabit(
        username: 'FitnessGuru',
        habitName: 'Утренняя пробежка',
        time: '07:00',
      ),
      UpcomingHabit(
        username: 'Maria_fit',
        habitName: 'Медитация',
        time: '08:30',
      ),
      UpcomingHabit(
        username: 'John_doe',
        habitName: 'Чтение книги',
        time: '09:00',
      ),
      UpcomingHabit(
        username: 'Alex123',
        habitName: 'Йога',
        time: '10:00',
      ),
    ];

    // Ограничиваем высоту, чтобы внутри ScrollView не было бесконечной
    final availableHeight = MediaQuery.of(context).size.height - kToolbarHeight;

    return SizedBox(
      height: availableHeight,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Левая колонка: скроллимый контент
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          GroupHeader(
                            groupName: 'Команда Здоровья',
                            members: members,
                          ),
                          const SizedBox(height: 40),
                          RecentAchievements(achievements: recentAchievements),
                          const SizedBox(height: 40),
                          UpcomingHabits(habits: upcomingHabits),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 40),
            // Правая колонка: лидерборд и чат
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  AchievementLeaderboard(userAchievements: achievements),
                  const SizedBox(height: 40),
                  Expanded(child: GroupChat()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

