import 'package:flutter/material.dart';
import 'package:website/pages/achievements_page.dart';
import 'package:website/pages/groups_page.dart';
import 'package:website/pages/habits_page.dart';
import 'package:website/pages/home_page.dart';
import 'package:website/pages/new_habit_page.dart';
import 'package:website/pages/profile_page.dart';
import 'package:website/pages/settings_page.dart';
import '../services/api_manager.dart';
import '../widgets/nav_button.dart';
import '../widgets/navigate_bar.dart';

abstract class TemplatePage extends StatelessWidget {
  final String title = 'Empty Page';
  final NavigationOptions page = NavigationOptions.home;
  final ApiManager apiManager;

  const TemplatePage({super.key, required this.apiManager});

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
        _buildScrollableContent(),
      ],
    );
  }

  Widget _buildScrollableContent() {
    return Expanded(
      child: getMainArea(),
    );
  }

  TemplatePage? changePage(NavigationOptions type) {
    if (page == type) return null;
    switch (type) {
      case NavigationOptions.home:
        return HomePage(apiManager);
      case NavigationOptions.habits:
        return HabitsPage(apiManager);
      case NavigationOptions.newHabit:
        return NewHabitPage(apiManager);
      case NavigationOptions.groups:
        return GroupsPage(apiManager);
      case NavigationOptions.achievements:
        return AchievementsPage(apiManager);
      case NavigationOptions.profile:
        return ProfilePage(apiManager);
      case NavigationOptions.settings:
        return SettingsPage(apiManager);
      default:
        return HomePage(apiManager);
    }
  }

  Widget getMainArea() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      // ! here is main area !
    );
  }
}
