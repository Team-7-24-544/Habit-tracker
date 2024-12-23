import 'package:flutter/material.dart';
import '../../models/habit_settings.dart';
import '../../models/habit_template.dart';
import '../../services/new_habit_service.dart';
import 'habit_settings_form.dart';
import 'habit_template_list.dart';

class HabitCreationArea extends StatefulWidget {
  final Function(BuildContext) onHabitCreated;

  const HabitCreationArea({
    super.key,
    required this.onHabitCreated,
  });

  @override
  State<HabitCreationArea> createState() => _HabitCreationAreaState();
}

class _HabitCreationAreaState extends State<HabitCreationArea> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isCreatingCustomHabit = false;
  HabitTemplate? _selectedTemplate;

  void _handleTemplateSelected(HabitTemplate template) {
    setState(() {
      _selectedTemplate = template;
      _isCreatingCustomHabit = false;
    });
  }

  Future<void> _handleHabitSaved(HabitSettings settings) async {
    setState(() {});

    try {
      bool success;
      if (settings.timeTable != "{}") {
        success = await HabitService.saveNewHabit(settings);
      } else {
        success = false;
      }

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Привычка успешно создана!'),
              backgroundColor: Colors.green,
            ),
          );
        }
        if (mounted) widget.onHabitCreated(context);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ошибка при создании привычки'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Произошла ошибка: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }

  final List<Widget> children = [
    const SizedBox(height: 24),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          children[0],
          _buildMainContent(),
        ],
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
            _isCreatingCustomHabit ? 'Выбрать из шаблонов' : 'Создать свою привычку',
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
    return _isCreatingCustomHabit || _selectedTemplate != null
        ? HabitSettingsForm(
            initialSettings: _selectedTemplate != null ? _loadTemplate(_selectedTemplate!.id) : null,
            onSave: _handleHabitSaved,
          )
        : HabitTemplateList(
            onTemplateSelected: _handleTemplateSelected,
          );
  }

  HabitSettings _loadTemplate(String habitId) {
    return HabitSettings(
      name: _selectedTemplate!.name,
      description: _selectedTemplate!.description,
      timeTable: _selectedTemplate!.timeTable,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
