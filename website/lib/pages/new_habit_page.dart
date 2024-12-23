import 'package:flutter/material.dart';
import 'package:website/pages/template_page.dart';
import '../widgets/navigation_widgets/nav_button.dart';
import '../widgets/new_habit_widgets/habit_creation_area.dart';

class NewHabitPage extends TemplatePage {
  @override
  String get title => 'New Habit Page';

  @override
  NavigationOptions get page => NavigationOptions.newHabit;

  void _onHabitCreated(BuildContext context) {
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

  const NewHabitPage({super.key});

  @override
  Widget getMainArea() {
    return HabitCreationArea(onHabitCreated: _onHabitCreated);
  }
}
