import 'package:flutter/material.dart';
import 'package:website/pages/achievements_page.dart';
import 'package:website/pages/groups_page.dart';
import 'package:website/pages/habits_page.dart';
import 'package:website/pages/home_page.dart';
import 'package:website/pages/new_habit_page.dart';
import 'package:website/pages/profile_page.dart';
import 'package:website/pages/settings_page.dart';
import '../widgets/nav_button.dart';
import '../widgets/navigate_bar.dart';

abstract class TemplatePage extends StatelessWidget {
  final String title = 'Empty Page';
  final NavigationOptions page = NavigationOptions.home;

  const TemplatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: Scaffold(
        body: SafeArea(
          child: _buildMainArea(),
        ),
      ),
    );
  }

  Widget _buildMainArea() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NavigateBar(activeOption: page, goTo: changePage),
        Expanded(
          child: _buildScrollableContent(),
        ),
      ],
    );
  }

  Widget _buildScrollableContent() {
    return Expanded(
      child: getMainArea(),
    );
  }

  TemplatePage changePage(NavigationOptions type) {
    switch (type) {
      case NavigationOptions.home:
        return HomePage();
      case NavigationOptions.habits:
        return const HabitsPage();
      case NavigationOptions.newHabit:
        return const NewHabitPage();
      case NavigationOptions.groups:
        return const GroupsPage();
      case NavigationOptions.achievements:
        return const AchievementsPage();
      case NavigationOptions.profile:
        return const ProfilePage();
      case NavigationOptions.settings:
        return const SettingsPage();
      default:
        return HomePage();
    }
  }

  Widget getMainArea() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      // ! here is main area !
    );
  }
}
