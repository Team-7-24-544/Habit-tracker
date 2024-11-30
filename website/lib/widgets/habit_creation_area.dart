import 'package:flutter/material.dart';
import '../models/habit_template.dart';
import '../models/habit_settings.dart';
import 'habit_template_list.dart';
import 'habit_settings_form.dart';

class HabitCreationArea extends StatefulWidget {
  const HabitCreationArea({super.key});

  @override
  State<HabitCreationArea> createState() => _HabitCreationAreaState();
}

class _HabitCreationAreaState extends State<HabitCreationArea> {
  bool _isCreatingCustomHabit = false;
  HabitTemplate? _selectedTemplate;

  void _handleTemplateSelected(HabitTemplate template) {
    setState(() {
      _selectedTemplate = template;
      _isCreatingCustomHabit = false;
    });
  }

  void _handleHabitSaved(HabitSettings settings) {
    // TODO: Implement habit saving logic
    print('Saving habit with settings: ${settings.name}');
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildMainContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Создание новой привычки',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              _isCreatingCustomHabit = !_isCreatingCustomHabit;
              _selectedTemplate = null;
            });
          },
          icon: Icon(
            _isCreatingCustomHabit ? Icons.list : Icons.add,
            size: 20,
          ),
          label: Text(
            _isCreatingCustomHabit
                ? 'Выбрать из шаблонов'
                : 'Создать свою привычку',
            style: const TextStyle(fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return Expanded(
      child: _isCreatingCustomHabit || _selectedTemplate != null
          ? HabitSettingsForm(
              initialSettings: _selectedTemplate != null
                  ? HabitSettings(
                      name: _selectedTemplate!.name,
                      description: _selectedTemplate!.description,
                      timeOfDay: TimeOfDay.now(),
                    )
                  : null,
              onSave: _handleHabitSaved,
            )
          : HabitTemplateList(
              onTemplateSelected: _handleTemplateSelected,
            ),
    );
  }
}