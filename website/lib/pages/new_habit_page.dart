import 'package:flutter/material.dart';
import 'package:website/pages/template_page.dart';
import '../widgets/nav_button.dart';
import '../widgets/habit_creation_area.dart';

class NewHabitPage extends TemplatePage {
  final String title = 'New Habit Page';
  final NavigationOptions page = NavigationOptions.newHabit;

  const NewHabitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const NewHabitPageContent(),
    );
  }
}

class NewHabitPageContent extends StatelessWidget {
  const NewHabitPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          //const NavigateBar(),
          const HabitCreationArea(),
        ],
      ),
    );
  }
}