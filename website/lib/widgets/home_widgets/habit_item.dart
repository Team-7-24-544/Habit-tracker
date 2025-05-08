import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/habit.dart';

class HabitItem extends StatefulWidget {
  final Habit habit;
  final Function(String) onToggle;

  const HabitItem({Key? key, required this.habit, required this.onToggle})
      : super(key: key);

  @override
  _HabitItemState createState() => _HabitItemState();
}

class _HabitItemState extends State<HabitItem> {
  double alpha = 1.0;
  bool pressed = false;

  void onPressed() {
    var now = DateTime.now();
    var habitTimeStart = DateFormat('HH:mm').parse(widget.habit.start);
    var habitTimeEnd = DateFormat('HH:mm').parse(widget.habit.end);

    var habitDateTimeStart = DateTime(now.year, now.month, now.day,
        habitTimeStart.hour, habitTimeStart.minute);
    var habitDateTimeEnd = DateTime(
        now.year, now.month, now.day, habitTimeEnd.hour, habitTimeEnd.minute);

    if (now.isAfter(habitDateTimeStart) && !pressed) {
      widget.onToggle(widget.habit.id);
      pressed = true;
    }
    if (now.isBefore(habitDateTimeEnd)) {
      setState(() {
        alpha = 0.4;
        widget.habit.isEnabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    alpha = widget.habit.isEnabled ? 1.0 : 0.4;
    var schedule = '[${widget.habit.start}-${widget.habit.end}] ';
    return Opacity(
      opacity: alpha,
      child: Card(
        child: ListTile(
          leading: IconButton(
            icon: Icon(
              widget.habit.completed
                  ? Icons.check_circle
                  : Icons.circle_outlined,
              color: widget.habit.completed ? Colors.green : Colors.grey,
            ),
            onPressed: onPressed,
          ),
          title: Text(
            widget.habit.name,
            style: TextStyle(
              decoration:
                  widget.habit.completed ? TextDecoration.lineThrough : null,
              color: widget.habit.completed ? Colors.grey : Colors.grey[800],
            ),
          ),
          subtitle: Text(
            schedule + widget.habit.description,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }
}
