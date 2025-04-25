import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:website/pages/template_page.dart';

import '../models/MetaInfo.dart';
import '../services/api_manager.dart';
import '../services/api_query.dart';
import '../services/logger.dart';
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
  List<int> reminderTimes = [];
  List<Map<String, dynamic>> daysOff = [];

  _ReminderSettingsPageState() {
    loadData();
  }

  Future<void> loadData() async {
    final apiManager = MetaInfo.getApiManager();
    ApiQuery query =
        ApiQueryBuilder().path(QueryPaths.userSettingsLoad).build();

    ApiResponse response = await apiManager.get(query);
    handleApiError(response: response, context: context);

    if (response.success &&
        response.body.containsKey('reminders') &&
        response.body.containsKey('weekends')) {
      setState(() {
        reminderTimes = List.from(response.body['reminders']);
        daysOff = List.from(response.body['weekends']);
      });
    } else if (response.success) {
      showErrorToUser(context, 500, "Некорректный ответ сервера");
      logError(500, "Некорректный ответ сервера", response.body);
    }
  }

  Future<void> _saveSettings() async {
    final apiManager = MetaInfo.getApiManager();
    ApiQuery query = ApiQueryBuilder()
        .path(QueryPaths.userSettingsSetSettings)
        .addParameter('reminders', reminderTimes)
        .addParameter('weekends', daysOff)
        .build();
    var response = await apiManager.post(query);
    handleApiError(response: response, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReminderTimesSettings(
            reminderTimes: reminderTimes,
            onSave: _saveSettings,
            onUpdate: (newList) => setState(() => reminderTimes = newList)),
        SizedBox(height: 24),
        NotificationSettings(),
        SizedBox(height: 24),
        DaysOffSettings(
          daysOff: daysOff,
          onSave: _saveSettings,
          onUpdate: (newList) => setState(() => daysOff = newList),
        ),
      ],
    );
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

class NotificationSettings extends StatefulWidget {
  @override
  _NotificationSettingsState createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool option1 = false;
  bool option2 = false;
  bool option3 = false;
  bool option4 = false;

  @override
  void initState() {
    super.initState();
    loadOptions();
  }

  Future<void> loadOptions() async {
    final apiManager = MetaInfo.getApiManager();
    ApiQuery query =
        ApiQueryBuilder().path(QueryPaths.userSettingsLoadToggles).build();

    ApiResponse response = await apiManager.get(query);
    handleApiError(response: response, context: context);

    if (response.success && response.body.containsKey('toggles')) {
      setState(() {
        final Map<String, bool> habitsJson = Map.from(response.body['toggles']);
        option1 = habitsJson['option1'] ?? false;
        option2 = habitsJson['option2'] ?? false;
        option3 = habitsJson['option3'] ?? false;
        option4 = habitsJson['option4'] ?? false;
      });
    } else if (response.success) {
      showErrorToUser(context, 500, "Некорректный ответ сервера");
      logError(500, "Некорректный ответ сервера", response.body);
    }
  }

  Future<void> saveOptions() async {
    final apiManager = MetaInfo.getApiManager();

    ApiQuery query = ApiQueryBuilder()
        .path(QueryPaths.userSettingsSetToggles)
        .addParameter('option1', option1)
        .addParameter('option2', option2)
        .addParameter('option3', option3)
        .addParameter('option4', option4)
        .build();
    var response = await apiManager.post(query);
    handleApiError(response: response, context: context);
  }

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
              value: option1,
              onChanged: (value) => {
                setState(() {
                  option1 = value!;
                }),
                saveOptions()
              },
            ),
            CheckboxListTile(
              title: Text('Ежедневный план привычек'),
              subtitle: Text(
                  'Утреннее напоминание со списком запланированных привычек на текущий день'),
              value: option2,
              onChanged: (value) => {
                setState(() {
                  option2 = value!;
                }),
                saveOptions()
              },
            ),
            CheckboxListTile(
              title: Text('Итоги дня'),
              subtitle:
                  Text('Краткая сводка вашей активности: ежедневно в 20:00'),
              value: option3,
              onChanged: (value) => {
                setState(() {
                  option3 = value!;
                }),
                saveOptions()
              },
            ),
            CheckboxListTile(
              title: Text('Итоги недели'),
              subtitle: Text(
                  'Краткая сводка вашей активности: еженедельно в воскресенье'),
              value: option4,
              onChanged: (value) => {
                setState(() {
                  option4 = value!;
                }),
                saveOptions()
              },
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
  String? _startTime;
  String? _endTime;

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final initialTime = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = formatTimeOfDay(picked);
        } else {
          _endTime = formatTimeOfDay(picked);
        }
      });
    }
  }

  void _addDayOff() {
    if (_selectedDay != null && _startTime != null && _endTime != null) {
      DateFormat format = DateFormat('HH:mm');
      DateTime t1 = format.parse(_startTime!);
      DateTime t2 = format.parse(_endTime!);
      if (t1.isAfter(t2)) {
        showErrorToUser(context, -1, "Время начала не может быть позже конца");
      } else {
        final newEntry = {
          'day': _days.indexOf(_selectedDay!).toString(),
          'start': _startTime!,
          'end': _endTime!,
        };
        widget.onUpdate([...widget.daysOff, newEntry]);
      }
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
                    title: Text(_startTime ?? 'Начало'),
                    trailing: Icon(Icons.access_time),
                    onTap: () => _selectTime(context, true),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(_endTime ?? 'Конец'),
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
                      '${_days[int.parse(entry.value['day'])]}: ${entry.value['start']} - ${entry.value['end']}'),
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

String formatTimeOfDay(TimeOfDay time) {
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  final format = DateFormat('HH:mm');
  return format.format(dt);
}
