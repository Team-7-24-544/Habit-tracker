import 'package:flutter/material.dart';
import 'package:website/pages/achievements_page.dart';
import 'package:website/pages/groups_page.dart';
import 'package:website/pages/habits_page.dart';
import 'package:website/pages/home_page.dart';
import 'package:website/pages/new_habit_page.dart';
import 'package:website/pages/profile_page.dart';
import 'package:website/pages/settings_page.dart';
import '../widgets/navigation_widgets/nav_button.dart';
import '../widgets/navigation_widgets/navigate_bar.dart';

abstract class TemplatePage extends StatelessWidget {
  String get title => 'Empty Page';

  NavigationOptions get page => NavigationOptions.home;

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
          child: _buildMainArea(context),
        ),
      ),
    );
  }

  Widget _buildMainArea(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NavigateBar(activeOption: page, goTo: changePage),
        _buildScrollableContent(context),
      ],
    );
  }

  Widget _buildScrollableContent(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: getMainArea(context),
        ),
      ),
    );
  }

  TemplatePage? changePage(NavigationOptions type) {
    if (page == type) return null;
    switch (type) {
      case NavigationOptions.home:
        return HomePage();
      case NavigationOptions.habits:
        return HabitsPage();
      case NavigationOptions.newHabit:
        return NewHabitPage();
      case NavigationOptions.groups:
        return GroupsPage();
      case NavigationOptions.achievements:
        return AchievementsPage();
      case NavigationOptions.profile:
        return ProfilePage();
      case NavigationOptions.settings:
        return SettingsPage();
      default:
        return HomePage();
    }
  }

  Widget getMainArea(BuildContext context) {
    return Padding(padding: EdgeInsets.all(16.0));
  }
}
