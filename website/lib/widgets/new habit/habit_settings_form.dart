import 'package:flutter/material.dart';
import '../../models/habit_settings.dart';

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
  late TimeOfDay _selectedTime;
  late List<bool> _selectedDays;
  late int _durationInDays;
  late int _repetitionsPerDay;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialSettings?.name ?? '');
    _descriptionController = TextEditingController(text: widget.initialSettings?.description ?? '');
    _selectedTime = widget.initialSettings?.timeOfDay ?? TimeOfDay.now();
    _selectedDays = widget.initialSettings?.weekDays ?? List.filled(7, true);
    _durationInDays = widget.initialSettings?.durationInDays ?? 30;
    _repetitionsPerDay = widget.initialSettings?.repetitionsPerDay ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _boxDecoration(),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16), // Добавим отступы с всех сторон
          child: Column(
            children: [
              _buildTextField(
                controller: _nameController,
                label: 'Название привычки',
                validator: (value) => value == null || value.isEmpty ? 'Пожалуйста, введите название' : null,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _descriptionController,
                label: 'Описание',
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              _buildTimeSelector(),
              const SizedBox(height: 24),
              _buildWeekDaysSelector(),
              const SizedBox(height: 24),
              _buildDurationSelector(),
              const SizedBox(height: 24),
              _buildRepetitionsSelector(),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveHabit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Сохранить привычку',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).primaryColor),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int? maxLines,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(label),
      maxLines: maxLines ?? 1,
      validator: validator,
    );
  }

  Widget _buildTimeSelector() {
    return Card(
      elevation: 0,
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: ListTile(
        title: const Text('Время выполнения'),
        trailing: Text(
          _selectedTime.format(context),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onTap: () async {
          final TimeOfDay? time = await showTimePicker(
            context: context,
            initialTime: _selectedTime,
          );
          if (time != null) {
            setState(() => _selectedTime = time);
          }
        },
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
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  Widget _buildDurationSelector() {
    return _buildSlider(
      title: 'Длительность',
      value: _durationInDays.toDouble(),
      min: 1,
      max: 365,
      divisions: 364,
      label: '$_durationInDays дней',
      onChanged: (value) => setState(() => _durationInDays = value.round()),
    );
  }

  Widget _buildRepetitionsSelector() {
    return _buildSlider(
      title: 'Повторений в день',
      value: _repetitionsPerDay.toDouble(),
      min: 1,
      max: 10,
      divisions: 9,
      label: '$_repetitionsPerDay раз',
      onChanged: (value) => setState(() => _repetitionsPerDay = value.round()),
    );
  }

  Widget _buildSlider({
    required String title,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String label,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          label: label,
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _saveHabit() {
    if (_formKey.currentState!.validate()) {
      final settings = HabitSettings(
        name: _nameController.text,
        description: _descriptionController.text,
        timeOfDay: _selectedTime,
        weekDays: _selectedDays,
        durationInDays: _durationInDays,
        repetitionsPerDay: _repetitionsPerDay,
      );
      widget.onSave(settings);
    }
  }
}
