import 'package:flutter/material.dart';

TableCell createDayCell(int day, String emotion) {
  return TableCell(child: DayCell(day: day, emotion: emotion));
}

class DayCell extends StatelessWidget {
  final int day;
  final String emotion;

  const DayCell({super.key, required this.day, required this.emotion});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 55,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day.toString(),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
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
    );
  }
}
