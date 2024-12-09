import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../services/habit_service.dart';

class HabitChecklist extends StatefulWidget {
  const HabitChecklist({super.key});

  @override
  State<HabitChecklist> createState() => _HabitChecklistState();
}

class _HabitChecklistState extends State<HabitChecklist> {
  final HabitService _habitService = HabitService();
  final List<Habit> _habits = [
    Habit(
      id: '1',
      name: 'Утренняя медитация',
      description: '10 минут медитации после пробуждения',
    ),
    Habit(
      id: '2',
      name: 'Физические упражнения',
      description: '30 минут активности',
    ),
    Habit(
      id: '3',
      name: 'Чтение',
      description: '20 страниц книги',
    ),
  ];

  Future<void> _toggleHabit(String habitId) async {
    final habitIndex = _habits.indexWhere((habit) => habit.id == habitId);
    if (habitIndex != -1) {
      final newCompleted = !_habits[habitIndex].completed;

      // Вызываем сервисный метод для обработки изменения состояния
      await _habitService.markHabitAsCompleted(habitId, newCompleted);

      // Обновляем локальное состояние после успешного выполнения сервисного метода
      setState(() {
        _habits[habitIndex] = _habits[habitIndex].copyWith(
          completed: newCompleted,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ежедневные привычки',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: _habits.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final habit = _habits[index];
                    return Card(
                      child: ListTile(
                        leading: IconButton(
                          icon: Icon(
                            habit.completed
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: habit.completed ? Colors.green : Colors.grey,
                          ),
                          onPressed: () => _toggleHabit(habit.id),
                        ),
                        title: Text(
                          habit.name,
                          style: TextStyle(
                            decoration: habit.completed
                                ? TextDecoration.lineThrough
                                : null,
                            color: habit.completed
                                ? Colors.grey
                                : Colors.grey[800],
                          ),
                        ),
                        subtitle: Text(
                          habit.description,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
