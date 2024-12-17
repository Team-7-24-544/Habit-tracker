import 'package:flutter/material.dart';

class TimeSlot extends StatefulWidget {
  final Function(int) onDelete;
  final int index;

  const TimeSlot({
    Key? key,
    required this.onDelete,
    required this.index,
  }) : super(key: key);

  @override
  TimeSlotState createState() => TimeSlotState();

  Map<String, String> getTimeData() {
    final state = _timeSlotKey.currentState;
    if (state != null) {
      return state.getTimeData();
    }
    return {
      'startTime': '9:00',
      'endTime': '10:00',
    };
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
      'startTime': '${_startTime.hour}:${_startTime.minute.toString().padLeft(2, '0')}',
      'endTime': '${_endTime.hour}:${_endTime.minute.toString().padLeft(2, '0')}',
    };
  }
}