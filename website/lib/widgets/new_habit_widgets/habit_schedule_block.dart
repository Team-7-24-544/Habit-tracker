import 'package:flutter/material.dart';
import 'time_slot.dart';

class HabitScheduleBlock extends StatefulWidget {
  final Function(int) onDelete;
  final int blockIndex;

  const HabitScheduleBlock({
    Key? key,
    required this.onDelete,
    required this.blockIndex,
  }) : super(key: key);

  @override
  HabitScheduleBlockState createState() => HabitScheduleBlockState();

  Map<String, dynamic> getScheduleData() {
    final state = _habitScheduleBlockKey.currentState;
    if (state != null) {
      return state.getScheduleData();
    }
    return {
      'days': List.filled(7, false),
      'timeSlots': [
        {
          'startTime': '9:00',
          'endTime': '10:00',
        },
      ],
    };
  }

  static final GlobalKey<HabitScheduleBlockState> _habitScheduleBlockKey =
      GlobalKey<HabitScheduleBlockState>();
}

class HabitScheduleBlockState extends State<HabitScheduleBlock> {
  final List<bool> _selectedDays = List.filled(7, false);
  final List<GlobalKey<TimeSlotState>> _timeSlotKeys = [];
  final List<TimeSlot> _timeSlots = [];

  @override
  void initState() {
    super.initState();
    _addInitialTimeSlot();
  }

  void _addInitialTimeSlot() {
    final key = GlobalKey<TimeSlotState>();
    _timeSlotKeys.add(key);
    _timeSlots.add(TimeSlot(
      key: key,
      onDelete: _removeTimeSlot,
      index: 0,
    ));
  }

  void _addTimeSlot() {
    setState(() {
      final key = GlobalKey<TimeSlotState>();
      _timeSlotKeys.add(key);
      _timeSlots.add(TimeSlot(
        key: key,
        onDelete: _removeTimeSlot,
        index: _timeSlots.length,
      ));
    });
  }

  void _removeTimeSlot(int index) {
    if (_timeSlots.length > 1) {
      setState(() {
        _timeSlots.removeAt(index);
        _timeSlotKeys.removeAt(index);
        for (var i = index; i < _timeSlots.length; i++) {
          _timeSlots[i] = TimeSlot(
            key: _timeSlotKeys[i],
            onDelete: _removeTimeSlot,
            index: i,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Расписание',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (widget.blockIndex > 0)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => widget.onDelete(widget.blockIndex),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _buildWeekDaysSelector(),
            const SizedBox(height: 16),
            ..._timeSlots,
            const SizedBox(height: 8),
            _buildAddTimeSlotButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekDaysSelector() {
    const days = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Дни недели',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        ToggleButtons(
          isSelected: _selectedDays,
          onPressed: (index) {
            setState(() {
              _selectedDays[index] = !_selectedDays[index];
            });
          },
          borderRadius: BorderRadius.circular(8),
          selectedColor: Colors.white,
          fillColor: Theme.of(context).primaryColor,
          color: Colors.grey.shade700,
          constraints: const BoxConstraints(minWidth: 45, minHeight: 45),
          children: days.map((day) => Text(day)).toList(),
        ),
      ],
    );
  }

  Widget _buildAddTimeSlotButton() {
    return Center(
      child: TextButton.icon(
        onPressed: _addTimeSlot,
        icon: const Icon(Icons.add),
        label: const Text('Добавить время'),
      ),
    );
  }

  Map<String, dynamic> getScheduleData() {
    return {
      'days': _selectedDays,
      'timeSlots': _timeSlots.map((slot) {
        final state = (slot.key as GlobalKey<TimeSlotState>).currentState;
        if (state != null) {
          return state.getTimeData();
        }
        return {
          'startTime': '9:00',
          'endTime': '10:00',
        };
      }).toList(),
    };
  }
}