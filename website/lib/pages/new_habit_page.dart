import 'package:flutter/material.dart';
import 'package:website/pages/template_page.dart';
import '../services/api_manager.dart';
import '../widgets/nav_button.dart';
import '../widgets/new habit/habit_creation_area.dart';

class NewHabitPage extends TemplatePage {
  final String title = 'New Habit Page';
  final NavigationOptions page = NavigationOptions.newHabit;

  var _habitService;

  void _onHabitCreated(BuildContext context) {
    // Здесь можно добавить логику обновления данных после создания привычки
    // Например, обновить список привычек или состояние приложения
    //_habitService.refreshHabits();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => changePage(NavigationOptions.habits)!,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  NewHabitPage(ApiManager apiManager, {super.key}) : super(apiManager: apiManager);

  @override
  Widget getMainArea() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: HabitCreationArea(
        apiManager: apiManager,
        onHabitCreated: _onHabitCreated,
      ),
    );
  }
}
