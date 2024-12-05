import 'package:flutter/material.dart';
import 'package:website/pages/template_page.dart';
import '../services/api_manager.dart';
import '../widgets/nav_button.dart';
import '../widgets/habit_creation_area.dart';

class NewHabitPage extends TemplatePage {
  final String title = 'New Habit Page';
  final NavigationOptions page = NavigationOptions.newHabit;

  const NewHabitPage(ApiManager apiManager, {super.key})
      : super(apiManager: apiManager);

  @override
  Widget getMainArea() {
    return const Expanded(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: HabitCreationArea(),
      ),
    );
  }
}
