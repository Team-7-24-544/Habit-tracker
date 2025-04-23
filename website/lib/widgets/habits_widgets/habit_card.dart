import 'package:flutter/material.dart';
import '../../models/MetaInfo.dart';
import '../../models/MetaKeys.dart';
import '../../models/habit.dart';
import '../../services/habits_service.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onTap;
  final Function(bool) onStatusChanged;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onTap,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      habit.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Switch(
                    value: habit.isEnabled,
                    onChanged: null,
                    activeColor: Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                habit.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              _buildScheduleSection(context),
              const SizedBox(height: 20),
              _buildProgressSection(),
              const SizedBox(height: 16),
              _buildCompletionCheckbox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.schedule, color: Colors.blue),
                  const SizedBox(width: 12),
                  const Text(
                    'Расписание',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _showScheduleEditor(context),
                tooltip: 'Редактировать расписание',
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (habit.start.isNotEmpty)
            ...habit.start.split('\n').map((schedule) => Padding(
              padding: const EdgeInsets.only(left: 36, top: 4),
              child: Text(
                schedule,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ))
          else
            Padding(
              padding: const EdgeInsets.only(left: 36),
              child: Text(
                'Расписание не задано',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showScheduleEditor(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ScheduleEditorDialog(habit: habit),
    );
  }

  Widget _buildProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Прогресс',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(habit.progress * 100).round()}%',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: habit.progress,
            minHeight: 8,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletionCheckbox() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CheckboxListTile(
        value: habit.completed,
        onChanged: (value) => onStatusChanged(value ?? false),
        title: const Text(
          'Отметить как выполненное',
          style: TextStyle(fontSize: 16),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }
}

class ScheduleEditorDialog extends StatefulWidget {
  final Habit habit;

  const ScheduleEditorDialog({
    super.key,
    required this.habit,
  });

  @override
  State<ScheduleEditorDialog> createState() => _ScheduleEditorDialogState();
}

class _ScheduleEditorDialogState extends State<ScheduleEditorDialog> {
  final Map<String, List<TimeRange>> schedule = {
    'Понедельник': [],
    'Вторник': [],
    'Среда': [],
    'Четверг': [],
    'Пятница': [],
    'Суббота': [],
    'Воскресенье': [],
  };

  @override
  void initState() {
    super.initState();
    _parseExistingSchedule();
  }

  void _parseExistingSchedule() {
    if (widget.habit.start.isNotEmpty) {
      final scheduleLines = widget.habit.start.split('\n');
      for (var line in scheduleLines) {
        final parts = line.split(': ');
        if (parts.length == 2) {
          final day = parts[0];
          final times = parts[1].split('-');
          if (times.length == 2) {
            schedule[day]?.add(TimeRange(
              TimeOfDay(
                hour: int.parse(times[0].split(':')[0]),
                minute: int.parse(times[0].split(':')[1]),
              ),
              TimeOfDay(
                hour: int.parse(times[1].split(':')[0]),
                minute: int.parse(times[1].split(':')[1]),
              ),
            ));
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Редактировать расписание'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...schedule.entries.map((entry) => _buildDaySchedule(entry.key, entry.value)),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: _saveSchedule,
          child: const Text('Сохранить'),
        ),
      ],
    );
  }

  Widget _buildDaySchedule(String day, List<TimeRange> timeRanges) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...timeRanges.map((range) => _buildTimeRange(day, range)),
            TextButton.icon(
              onPressed: () => _addTimeRange(day),
              icon: const Icon(Icons.add),
              label: const Text('Добавить время'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRange(String day, TimeRange range) {
    return Row(
      children: [
        TextButton(
          onPressed: () => _selectTime(context, day, range, true),
          child: Text(range.start.format(context)),
        ),
        const Text(' - '),
        TextButton(
          onPressed: () => _selectTime(context, day, range, false),
          child: Text(range.end.format(context)),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _removeTimeRange(day, range),
        ),
      ],
    );
  }

  Future<void> _selectTime(BuildContext context, String day, TimeRange range, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? range.start : range.end,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          range.start = picked;
        } else {
          range.end = picked;
        }
      });
    }
  }

  void _addTimeRange(String day) {
    setState(() {
      schedule[day]?.add(TimeRange(
        const TimeOfDay(hour: 9, minute: 0),
        const TimeOfDay(hour: 10, minute: 0),
      ));
    });
  }

  void _removeTimeRange(String day, TimeRange range) {
    setState(() {
      schedule[day]?.remove(range);
    });
  }

  Future<void> _saveSchedule() async {
    final userId = MetaInfo.instance.get(MetaKeys.userId);
    if (userId == null) return;

    Map<String, List<Map<String, String>>> formattedSchedule = {};
    
    schedule.forEach((day, timeRanges) {
      List<Map<String, String>> ranges = [];
      for (var range in timeRanges) {
        ranges.add({
          'start': '${range.start.hour.toString().padLeft(2, '0')}:${range.start.minute.toString().padLeft(2, '0')}',
          'end': '${range.end.hour.toString().padLeft(2, '0')}:${range.end.minute.toString().padLeft(2, '0')}'
        });
      }
      String englishDay = _convertDayToEnglish(day);
      formattedSchedule[englishDay] = ranges;
    });

    try {
      await HabitsService.updateHabitSchedule(userId, widget.habit.id, formattedSchedule);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Расписание успешно обновлено'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка при обновлении расписания: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _convertDayToEnglish(String russianDay) {
    final Map<String, String> dayMapping = {
      'Понедельник': 'monday',
      'Вторник': 'tuesday',
      'Среда': 'wednesday',
      'Четверг': 'thursday',
      'Пятница': 'friday',
      'Суббота': 'saturday',
      'Воскресенье': 'sunday',
    };
    return dayMapping[russianDay] ?? russianDay.toLowerCase();
  }
}

class TimeRange {
  TimeOfDay start;
  TimeOfDay end;

  TimeRange(this.start, this.end);
}