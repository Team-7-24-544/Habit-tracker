import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:website/models/MetaInfo.dart';
import 'package:website/models/MetaKeys.dart';
import 'package:website/models/emotions.dart';
import 'package:website/services/calendar_emotions_service.dart';

import '../../services/habit_checklist_main.dart';
import 'calendar/day_cell.dart';
import 'calendar/empty_cell.dart';
import 'calendar/header_cell.dart';

class EmotionCalendarController {
  final GlobalKey<EmotionCalendarState> calendarKey = GlobalKey<EmotionCalendarState>();

  void setEmoji(int index) {
    calendarKey.currentState?.setTodayEmotion(index);
  }
}

class EmotionCalendar extends StatefulWidget {
  final EmotionCalendarController controller;

  const EmotionCalendar({super.key, required this.controller});

  @override
  EmotionCalendarState createState() => EmotionCalendarState();
}

class EmotionCalendarState extends State<EmotionCalendar> {
  late Map<DateTime, String> emotions;
  late DateTime selectedDate;
  Map<DateTime, bool> startDates = {};
  Map<DateTime, bool> endDates = {};
  String emotionToday = ' ';

  @override
  void initState() {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    emotions = {};
    setState(() {
      for (var day = 1; day <= daysInMonth; day++) {
        emotions[DateTime(firstDayOfMonth.year, firstDayOfMonth.month, day)] = ' ';
      }
    });

    updateEmotions();
    super.initState();
  }

  void setTodayEmotion(int index) {
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day);
    final emoji = EmotionData.emotions[index];
    setState(() {
      emotionToday = emoji.emoji;
      emotions[date] = emoji.emoji;
    });
    final userId = MetaInfo.instance.get(MetaKeys.userId) ?? 0;
    CalendarEmotionsService.setEmoji(userId, index);
  }

  Future<void> updateEmotions() async {
    final userId = MetaInfo.instance.get(MetaKeys.userId) ?? 0;
    final newEmotions = await CalendarEmotionsService.loadEmotions(userId);
    final newList = await loadHabitPeriods(MetaInfo.instance.get(MetaKeys.userId));
    if (mounted) {
      setState(() {
        newEmotions.forEach((key, value) {
          emotions[key] = value;
        });
      });
    }
    final updatedStartDates = Map<DateTime, bool>.from(startDates);
    final updatedEndDates = Map<DateTime, bool>.from(endDates);

    final dateFormatter = DateFormat('dd-MM-yyyy');

    for (var start in newList.item1.map((e) => dateFormatter.parse(e))) {
      if (updatedStartDates.keys.contains(start)) {
        updatedStartDates[start] = true;
      }
    }

    for (var end in newList.item2.map((e) => dateFormatter.parse(e))) {
      if (updatedEndDates.keys.contains(end)) {
        updatedEndDates[end] = true;
      }
    }

    setState(() {
      endDates = updatedEndDates;
      startDates = updatedStartDates;
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final startWeekday = firstDayOfMonth.weekday;
    final numberOfWeeks = ((daysInMonth + startWeekday - 1) / 7).ceil();

    const double headerHeight = 50.0;
    const double spacing = 14.0;
    const double cellHeight = calendarCellSize;
    const double padding = 28.0;
    final double totalHeight = headerHeight + spacing + cellHeight * (numberOfWeeks + 1) + padding;

    return SizedBox(
      height: totalHeight,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 14),
              Expanded(child: _buildCalendarTable(daysInMonth, startWeekday)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      DateFormat('MMMM yyyy').format(DateTime.now()),
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildCalendarTable(int daysInMonth, int startWeekday) {
    return Table(
      border: TableBorder.all(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        _buildHeaderRow(),
        ..._buildCalendarRows(daysInMonth, startWeekday),
      ],
    );
  }

  TableRow _buildHeaderRow() {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return TableRow(
      decoration: BoxDecoration(color: Colors.grey.shade100),
      children: weekdays.map((day) => TableCell(child: HeaderCell(day: day))).toList(),
    );
  }

  List<TableRow> _buildCalendarRows(int daysInMonth, int startWeekday) {
    List<TableRow> rows = [];
    int day = 1;
    final now = DateTime.now();

    for (int week = 0; week < 6; week++) {
      if (day > daysInMonth) break;

      List<TableCell> cells = [];
      for (int weekday = 1; weekday <= 7; weekday++) {
        if ((week == 0 && weekday < startWeekday) || day > daysInMonth) {
          cells.add(createEmptyCell());
        } else {
          final date = DateTime(now.year, now.month, day);

          if (!startDates.containsKey(date)) {
            startDates[date] = false;
          }
          if (!endDates.containsKey(date)) {
            endDates[date] = false;
          }
          final cell = createDayCell(day, emotions[date]!, startDates[date]!, endDates[date]!, now.day == day);
          cells.add(cell);
          day++;
        }
      }
      rows.add(TableRow(children: cells));
    }
    return rows;
  }
}

bool equalsDays(DateTime day1, DateTime day2) {
  return day1.year == day2.year && day1.month == day2.month && day1.day == day2.day;
}
