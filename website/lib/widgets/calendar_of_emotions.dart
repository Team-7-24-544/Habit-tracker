import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:website/models/emotions.dart';

import 'calendar/day_cell.dart';
import 'calendar/empty_cell.dart';
import 'calendar/header_cell.dart';

class EmotionCalendarController {
  final GlobalKey<EmotionCalendarState> calendarKey =
      GlobalKey<EmotionCalendarState>();

  void setEmoji(Emotion emoji) {
    calendarKey.currentState?.setTodayEmotion(emoji);
  }
}

class EmotionCalendar extends StatefulWidget {
  final Map<DateTime, String> emotions;
  final EmotionCalendarController controller;

  const EmotionCalendar(
      {super.key, required this.emotions, required this.controller});

  @override
  EmotionCalendarState createState() => EmotionCalendarState();
}

class EmotionCalendarState extends State<EmotionCalendar> {
  late Map<DateTime, String> emotions;
  late DateTime selectedDate;
  String emotionToday = ' ';

  @override
  void initState() {
    super.initState();
    emotions = widget.emotions;
    selectedDate = DateTime.now();
  }

  void setTodayEmotion(Emotion emoji) {
    final now = DateTime.now();
    setState(() {
      emotionToday = emoji.emoji;
      emotions[now] = emoji.emoji;
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

    final double totalHeight =
        headerHeight + spacing + cellHeight * (numberOfWeeks + 1) + padding;

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
      children: weekdays
          .map((day) => TableCell(child: HeaderCell(day: day)))
          .toList(),
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
          final emotion =
              equalsDays(date, now) ? emotionToday : (emotions[date] ?? ' ');
          cells.add(createDayCell(day, emotion));
          day++;
        }
      }
      rows.add(TableRow(children: cells));
    }
    return rows;
  }
}

bool equalsDays(DateTime day1, DateTime day2) {
  return day1.year == day2.year &&
      day1.month == day2.month &&
      day1.day == day2.day;
}
