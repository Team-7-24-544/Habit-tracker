import 'package:flutter/material.dart';
import '../../models/habit_settings.dart';
import 'habit_basic_info.dart';
import 'habit_schedule_block.dart';

class HabitSettingsForm extends StatefulWidget {
  final HabitSettings? initialSettings;
  final Function onSave;

  const HabitSettingsForm({
    super.key,
    this.initialSettings,
    required this.onSave,
  });

  @override
  State<HabitSettingsForm> createState() => _HabitSettingsFormState();
}

class _HabitSettingsFormState extends State<HabitSettingsForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  final List<HabitScheduleBlock> _scheduleBlocks = [];
  final List<GlobalKey<HabitScheduleBlockState>> _scheduleBlockKeys = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialSettings?.name ?? '');
    _descriptionController = TextEditingController(text: widget.initialSettings?.description ?? '');
    _addScheduleBlock();
  }

  Future<void> _saveHabit() async {
    if (_formKey.currentState!.validate()) {
      List<Map<String, dynamic>> schedules = [];
      for (var key in _scheduleBlockKeys) {
        final state = key.currentState;
        if (state != null) {
          schedules.add(state.getScheduleData());
        }
      }

      List<String> days = ['monday', 'tuesday', 'wednesday', "thursday", "friday", "saturday", "sunday"];
      Map<String, Map<String, String>> map_ = {};
      for (var schedule in schedules) {
        schedule["timeSlots"].forEach((slot) {
          for (int day = 0; day < 7; day++) {
            if (schedule["days"][day]) {
              if (!map_.containsKey('"${days[day]}"')) map_['"${days[day]}"'] = {};
              map_['"${days[day]}"']!['"${slot["startTime"]}"'] = '"${slot["endTime"]}"';
            }
          }
        });
      }
      HabitSettings settings = HabitSettings(
          name: _nameController.text, description: _descriptionController.text, timeTable: map_.toString());
      widget.onSave(settings);
    }
  }

  void _addScheduleBlock() {
    setState(() {
      final key = GlobalKey<HabitScheduleBlockState>();
      _scheduleBlockKeys.add(key);

      _scheduleBlocks.add(HabitScheduleBlock(
        onDelete: _removeScheduleBlock,
        blockIndex: _scheduleBlocks.length,
        key: key,
      ));
    });
  }

  void _removeScheduleBlock(int index) {
    if (_scheduleBlocks.length > 1) {
      setState(() {
        _scheduleBlockKeys.removeAt(index);
        _scheduleBlocks.removeAt(index);

        for (int i = 0; i < _scheduleBlocks.length; i++) {
          _scheduleBlocks[i] = HabitScheduleBlock(
            onDelete: _removeScheduleBlock,
            blockIndex: i,
            key: _scheduleBlockKeys[i],
          );
        }
      });
    }
  }

  Widget _buildAddBlockButton() {
    return Center(
      child: TextButton.icon(
        onPressed: _addScheduleBlock,
        icon: const Icon(Icons.add),
        label: const Text('Добавить расписание'),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveHabit,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text('Сохранить привычку'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HabitBasicInfo(
              nameController: _nameController,
              descriptionController: _descriptionController,
            ),
            const SizedBox(height: 24),
            ..._scheduleBlocks,
            const SizedBox(height: 16),
            _buildAddBlockButton(),
            const SizedBox(height: 24),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }
}
