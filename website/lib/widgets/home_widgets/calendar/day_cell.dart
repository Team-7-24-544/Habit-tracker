import 'package:flutter/material.dart';
import 'package:pair/pair.dart';

import 'empty_cell.dart';

TableCell createDayCell(int day, String emotion, bool isNew, bool isDone, bool isToday) {
  return TableCell(child: DayCell(day: day, emotion: emotion, isNew: isNew, isDone: isDone, isToday: isToday));
}

class DayCell extends StatelessWidget {
  final int day;
  final String emotion;
  final double height = calendarCellSize;
  final bool isNew;
  final bool isDone;
  final bool isToday;

  const DayCell({
    super.key,
    required this.day,
    required this.emotion,
    this.isNew = false,
    this.isDone = false,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    var bgColor = isToday ? Color(int.parse('FFC9FFC6', radix: 16)) : Colors.transparent;
    var bgNumberColor = isToday ? Color(int.parse('FFFFFFFF', radix: 16)) : Colors.grey.shade300;
    return Container(
      height: height,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                emotion,
                style: const TextStyle(fontSize: 50),
              ),
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: bgNumberColor,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        day.toString(),
                        style: const TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isNew) Image.asset('web/icons/new.png', height: 15),
                        if (isDone) Image.asset('web/icons/done.png', height: 15),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
