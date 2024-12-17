import 'package:flutter/material.dart';
import 'habit_basic_info.dart';
import 'habit_schedule_block.dart';
import 'habit_schedule_block.dart';

class HabitCreationArea extends StatefulWidget {
  final Function(BuildContext) onHabitCreated;

  const HabitCreationArea({
    Key? key,
    required this.onHabitCreated,
  }) : super(key: key);

  @override
  State<HabitCreationArea> createState() => _HabitCreationAreaState();
}

class _HabitCreationAreaState extends State<HabitCreationArea> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<GlobalKey<HabitScheduleBlockState>> _scheduleBlockKeys = [];

  final List<HabitScheduleBlock> _scheduleBlocks = [];

  @override
  void initState() {
    super.initState();
    _addScheduleBlock();
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

  Future<void> _saveHabit() async {
    if (_formKey.currentState!.validate()) {
      List<Map<String, dynamic>> schedules = [];
      for (var key in _scheduleBlockKeys) {
        final state = key.currentState;
        if (state != null) {
          schedules.add(state.getScheduleData());
        }
      }

      final habitData = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'schedules': schedules,
      };

      // TODO: Отправить данные на сервер
      print(habitData); // Для отладки

      // Вызываем callback
      widget.onHabitCreated(context);
    }
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
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}