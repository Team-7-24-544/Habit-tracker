import 'package:flutter/material.dart';
import 'package:website/pages/template_page.dart';
import '../widgets/navigation_widgets/nav_button.dart';
import '../widgets/habits_widgets/habit_list.dart';

class HabitsPage extends TemplatePage {
  @override
  String get title => 'Habits Page';

  @override
  NavigationOptions get page => NavigationOptions.habits;

  const HabitsPage({super.key});

  @override
  Widget getMainArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Мои привычки',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildFilterButton(),
            _buildAddHabitButton(),
          ],
        ),
        const SizedBox(height: 24),
        const Expanded(
          child: HabitList(),
        ),
      ],
    );
  }

  Widget _buildFilterButton() {
    return OutlinedButton.icon(
      onPressed: () {
        // TODO: Implement filtering
      },
      icon: const Icon(Icons.filter_list),
      label: const Text('Фильтры'),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildAddHabitButton() {
    return ElevatedButton.icon(
      onPressed: () {
        // TODO: Navigate to new habit page
      },
      icon: const Icon(Icons.add),
      label: const Text('Добавить привычку'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}