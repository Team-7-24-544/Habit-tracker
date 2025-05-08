import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:website/models/habit.dart';
import 'package:website/pages/template_page.dart';

import '../widgets/navigation_widgets/nav_button.dart';

class HabitDetailPage extends TemplatePage {
  @override
  String get title => 'Habit Page';

  @override
  NavigationOptions get page => NavigationOptions.none;
  final LargeHabit habit;

  const HabitDetailPage({
    super.key,
    required this.habit,
  });

  @override
  Widget getMainArea(BuildContext context) {
    return HabitDetailsArea(habit: habit);
  }
}

class HabitDetailsArea extends StatefulWidget {
  final LargeHabit habit;

  const HabitDetailsArea({super.key, required this.habit});

  @override
  State<HabitDetailsArea> createState() => _HabitDetailsAreaState();
}

class _HabitDetailsAreaState extends State<HabitDetailsArea> {
  bool isEditingSchedule = false;

  @override
  Widget build(BuildContext context) {
    final habit = widget.habit;

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(habit),
          const SizedBox(height: 24),
          _buildStats(habit),
          const SizedBox(height: 24),
          _buildDateRange(habit),
          const SizedBox(height: 24),
          _buildSchedule(habit),
          const SizedBox(height: 24),
          _buildAchievements(habit),
        ],
      ),
    );
  }

  Widget _buildHeader(LargeHabit habit) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                habit.name,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  //todo
                  habit.pause = !habit.pause;
                });
              },
              icon: Icon(habit.pause ? Icons.play_arrow : Icons.pause),
              label: Text(habit.pause ? 'Возобновить' : 'Приостановить'),
              style: ElevatedButton.styleFrom(
                backgroundColor: habit.pause ? Colors.green : Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(habit.description,
            style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  Widget _buildStats(LargeHabit habit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatTile('Стрик', habit.streak.toString(), Icons.whatshot),
        _buildStatTile(
            'Выполнено', habit.toggled.toString(), Icons.check_circle),
        _buildStatTile('Пропущено', habit.missed.toString(), Icons.cancel),
      ],
    );
  }

  Widget _buildStatTile(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 30, color: Colors.blueGrey),
        const SizedBox(height: 8),
        Text(value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  Widget _buildDateRange(LargeHabit habit) {
    final startDate = _formatDate(habit.start);
    final endDate = habit.end != '-' ? _formatDate(habit.end) : '—';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildDateTile('Начало', startDate),
        _buildDateTile('Конец', endDate),
      ],
    );
  }

  String _formatDate(String rawDate) {
    try {
      final date = DateTime.parse(rawDate);
      return DateFormat('dd.MM.yyyy').format(date);
    } catch (_) {
      return rawDate;
    }
  }

  Widget _buildDateTile(String label, String date) {
    return Column(
      children: [
        Text(date,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  Widget _buildSchedule(LargeHabit habit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Расписание',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  isEditingSchedule = !isEditingSchedule;
                });
              },
              icon: const Icon(Icons.edit, size: 18),
              label: Text(isEditingSchedule ? 'Сохранить' : 'Изменить'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildScheduleView(habit.schedule),
      ],
    );
  }

  Widget _buildScheduleView(Map<String, Map<String, String>> schedule) {
    if (isEditingSchedule) {
      //todo
      return const Text('Редактирование расписания ещё не реализовано');
    }

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: schedule.entries.map((day) {
          final sessions = day.value.entries
              .map((entry) => '${entry.key} - ${entry.value}')
              .toList();

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_capitalize(day.key)}:',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: sessions.map((session) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          session,
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  Widget _buildAchievements(LargeHabit habit) {
    //todo
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Достижения',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (habit.achievements.isEmpty) const Text('Пока нет достижений'),
        ...habit.achievements.map((ach) => ListTile(
              leading: const Icon(Icons.star, color: Colors.amber),
              title: Text(ach),
            )),
      ],
    );
  }
}
