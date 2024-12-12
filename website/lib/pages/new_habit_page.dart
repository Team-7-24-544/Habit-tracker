import 'package:flutter/material.dart';
import 'package:website/pages/template_page.dart';
import '../services/api_manager.dart';
import '../widgets/nav_button.dart';
import '../widgets/habit_creation_area.dart';

class NewHabitPage extends TemplatePage {
  final String title = 'New Habit Page';
  final NavigationOptions page = NavigationOptions.newHabit;
  
  var _habitService;

  void _onHabitCreated() {
    // Здесь можно добавить логику обновления данных после создания привычки
    // Например, обновить список привычек или состояние приложения
    _habitService.refreshHabits();
  }
  
  NewHabitPage(ApiManager apiManager, {super.key})
      : super(apiManager: apiManager);

  @override
  Widget getMainArea() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: HabitCreationArea(apiManager: apiManager, onHabitCreated: () {  },),
      ),
    );
  }
}
