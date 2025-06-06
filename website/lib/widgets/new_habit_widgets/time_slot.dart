import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/logger.dart';

class TimeSlot extends StatefulWidget {
  final Function(int) onDelete;
  final int index;

  const TimeSlot({
    super.key,
    required this.onDelete,
    required this.index,
  });

  @override
  TimeSlotState createState() => TimeSlotState();

  Map<String, String> getTimeData() {
    final state = _timeSlotKey.currentState;
    if (state != null) {
      return state.getTimeData();
    }
    return {};
  }

  static final GlobalKey<TimeSlotState> _timeSlotKey =
      GlobalKey<TimeSlotState>();
}

class TimeSlotState extends State<TimeSlot> {
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          DateFormat format = DateFormat('HH:mm');
          DateTime t1 = format.parse('${_startTime.hour}:${_startTime.minute}');
          DateTime t2 = format.parse('${picked.hour}:${picked.minute}');
          if (t1.isAfter(t2)) {
            showErrorToUser(
                context, -1, "Время начала не может быть позже конца");
            return;
          }
          _endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: _buildTimeButton(context, true),
          ),
          const SizedBox(width: 16),
          const Text('—'),
          const SizedBox(width: 16),
          Expanded(
            child: _buildTimeButton(context, false),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => widget.onDelete(widget.index),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeButton(BuildContext context, bool isStartTime) {
    final time = isStartTime ? _startTime : _endTime;
    return OutlinedButton(
      onPressed: () => _selectTime(context, isStartTime),
      child: Text(time.format(context)),
    );
  }

  Map<String, String> getTimeData() {
    return {
      'startTime':
          "${_startTime.hour}:${_startTime.minute.toString().padLeft(2, '0')}",
      'endTime':
          "${_endTime.hour}:${_endTime.minute.toString().padLeft(2, '0')}",
    };
  }
}
