import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EmotionCalendar extends StatelessWidget {
  final Map<DateTime, String> emotions;

  const EmotionCalendar({
    super.key,
    required this.emotions,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final startWeekday = firstDayOfMonth.weekday;

    return SizedBox(
      height: 400,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 14),
              Expanded(
                child: _buildCalendarTable(daysInMonth, startWeekday),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      DateFormat('MMMM yyyy').format(DateTime.now()),
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildCalendarTable(int daysInMonth, int startWeekday) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final now = DateTime.now();

    return Table(
      border: TableBorder.all(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
          ),
          children: weekdays
              .map((day) => TableCell(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      alignment: Alignment.center,
                      child: Text(
                        day,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
        ..._buildCalendarRows(daysInMonth, startWeekday, now),
      ],
    );
  }

  List<TableRow> _buildCalendarRows(
      int daysInMonth, int startWeekday, DateTime now) {
    List<TableRow> rows = [];
    int day = 1;

    for (int week = 0; week < 6; week++) {
      if (day > daysInMonth) break;

      List<Widget> cells = [];
      for (int weekday = 1; weekday <= 7; weekday++) {
        if ((week == 0 && weekday < startWeekday) || day > daysInMonth) {
          cells.add(const TableCell(child: SizedBox(height: 50)));
        } else {
          final date = DateTime(now.year, now.month, day);
          final emotion = emotions[date] ?? '😶';

          cells.add(
            TableCell(
              child: Container(
                height: 55,
                padding: const EdgeInsets.all(4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      day.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: date.isBefore(now) ? Colors.black : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      emotion,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          );
          day++;
        }
      }
      rows.add(TableRow(children: cells));
    }

    return rows;
  }
}
