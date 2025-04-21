import 'package:flutter/material.dart';
import 'package:website/pages/template_page.dart';

import '../widgets/navigation_widgets/nav_button.dart';

class SettingsPage extends TemplatePage {
  @override
  String get title => 'Settings Page';

  @override
  NavigationOptions get page => NavigationOptions.settings;

  @override
  Widget getMainArea(BuildContext context) {
    return ReminderSettingsPage();
  }

  const SettingsPage({super.key});
}

class ReminderSettingsPage extends StatefulWidget {
  @override
  _ReminderSettingsPageState createState() => _ReminderSettingsPageState();
}

class _ReminderSettingsPageState extends State<ReminderSettingsPage> {
  List<int> reminderTimes = [5, 15, 30];
  bool _reminderAfterPeriod = true;
  bool _askIfStarted = true;
  bool _extraOption = false;
  List<Map<String, dynamic>> daysOff = [];

  void _saveReminderTimes() {}

  void _saveNotificationSettings() {}

  void _saveDaysOff() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReminderTimesSettings(
            reminderTimes: reminderTimes,
            onSave: _saveReminderTimes,
            onUpdate: (newList) => setState(() => reminderTimes = newList)),
        SizedBox(height: 24),
        NotificationSettings(
          reminderAfterPeriod: _reminderAfterPeriod,
          askIfStarted: _askIfStarted,
          extraOption: _extraOption,
          onSave: _saveNotificationSettings,
          onUpdate: updateOnOff,
        ),
        SizedBox(height: 24),
        DaysOffSettings(
          daysOff: daysOff,
          onSave: _saveDaysOff,
          onUpdate: (newList) => setState(() => daysOff = newList),
        ),
      ],
    );
  }

  void updateOnOff(newValues) {
    setState(() {
      _reminderAfterPeriod = newValues['afterPeriod'];
      _askIfStarted = newValues['askStarted'];
      _extraOption = newValues['extra'];
    });
  }
}

class ReminderTimesSettings extends StatefulWidget {
  final List<int> reminderTimes;
  final Function(List<int>) onUpdate;
  final VoidCallback onSave;

  ReminderTimesSettings(
      {required this.reminderTimes,
      required this.onUpdate,
      required this.onSave});

  @override
  _ReminderTimesSettingsState createState() => _ReminderTimesSettingsState();
}

class _ReminderTimesSettingsState extends State<ReminderTimesSettings> {
  final TextEditingController _timeController = TextEditingController();

  void _addTime() {
    final time = int.tryParse(_timeController.text);
    if (time != null) {
      widget.onUpdate([...widget.reminderTimes, time]);
      _timeController.clear();
    }
  }

  void _deleteTime(int index) {
    final newList = List<int>.from(widget.reminderTimes);
    newList.removeAt(index);
    widget.onUpdate(newList);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Время напоминания до начала',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
                'Добавьте время в минутах, за которое нужно присылать уведомление',
                style: TextStyle(color: Colors.grey)),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _timeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Минуты до начала',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addTime,
                ),
              ],
            ),
            SizedBox(height: 12),
            ...widget.reminderTimes.asMap().entries.map((entry) => ListTile(
                  title: Text('${entry.value} минут'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteTime(entry.key),
                  ),
                )),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: widget.onSave,
                child: Text('Сохранить время'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationSettings extends StatelessWidget {
  final bool reminderAfterPeriod;
  final bool askIfStarted;
  final bool extraOption;
  final Function(Map<String, bool>) onUpdate;
  final VoidCallback onSave;

  NotificationSettings({
    required this.reminderAfterPeriod,
    required this.askIfStarted,
    required this.extraOption,
    required this.onUpdate,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Настройки уведомлений',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            CheckboxListTile(
              title: Text('Напомнить об отметке результата'),
              subtitle: Text(
                  'Уведомление сразу после окончания периода привычки, чтобы не забыть отметить выполнение'),
              value: reminderAfterPeriod,
              onChanged: (value) => onUpdate({}),
            ),
            CheckboxListTile(
              title: Text('Ежедневный план привычек'),
              subtitle: Text(
                  'Утреннее напоминание со списком запланированных привычек на текущий день'),
              value: askIfStarted,
              onChanged: (value) => onUpdate({}),
            ),
            CheckboxListTile(
              title: Text('Итоги дня'),
              subtitle:
                  Text('Краткая сводка вашей активности: ежедневно в 20:00'),
              value: extraOption,
              onChanged: (value) => onUpdate({}),
            ),
            CheckboxListTile(
              title: Text('Итоги недели'),
              subtitle: Text(
                  'Краткая сводка вашей активности: еженедельно в воскресенье'),
              value: extraOption,
              onChanged: (value) => onUpdate({}),
            ),
          ],
        ),
      ),
    );
  }
}

class DaysOffSettings extends StatefulWidget {
  final List<Map<String, dynamic>> daysOff;
  final Function(List<Map<String, dynamic>>) onUpdate;
  final VoidCallback onSave;

  DaysOffSettings(
      {required this.daysOff, required this.onUpdate, required this.onSave});

  @override
  _DaysOffSettingsState createState() => _DaysOffSettingsState();
}

class _DaysOffSettingsState extends State<DaysOffSettings> {
  final List<String> _days = [
    'Понедельник',
    'Вторник',
    'Среда',
    'Четверг',
    'Пятница',
    'Суббота',
    'Воскресенье'
  ];
  String? _selectedDay;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final initialTime = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _addDayOff() {
    if (_selectedDay != null && _startTime != null && _endTime != null) {
      final newEntry = {
        'day': _selectedDay!,
        'start': _startTime!.format(context),
        'end': _endTime!.format(context),
      };
      widget.onUpdate([...widget.daysOff, newEntry]);
    }
  }

  void _removeDayOff(int index) {
    final newList = List<Map<String, dynamic>>.from(widget.daysOff);
    newList.removeAt(index);
    widget.onUpdate(newList);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Выходные дни',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Укажите дни и время, когда не присылать уведомления',
                style: TextStyle(color: Colors.grey)),
            SizedBox(height: 12),
            DropdownButton<String>(
              hint: Text('Выберите день'),
              value: _selectedDay,
              items: _days
                  .map((day) => DropdownMenuItem(
                        value: day,
                        child: Text(day),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedDay = value),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text(_startTime?.format(context) ?? 'Начало'),
                    trailing: Icon(Icons.access_time),
                    onTap: () => _selectTime(context, true),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(_endTime?.format(context) ?? 'Конец'),
                    trailing: Icon(Icons.access_time),
                    onTap: () => _selectTime(context, false),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _addDayOff,
              child: Text('Добавить выходной'),
            ),
            ...widget.daysOff.asMap().entries.map((entry) => ListTile(
                  title: Text(
                      '${entry.value['day']}: ${entry.value['start']} - ${entry.value['end']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _removeDayOff(entry.key),
                  ),
                )),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: widget.onSave,
                child: Text('Сохранить выходные'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
