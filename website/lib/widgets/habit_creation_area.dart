import 'package:flutter/material.dart';
import '../models/habit_template.dart';
import '../models/habit_settings.dart';
import 'habit_template_list.dart';
import 'habit_settings_form.dart';
import '../services/api_manager.dart';
import '../services/new_habbit_service.dart';

class HabitCreationArea extends StatefulWidget {
  final ApiManager apiManager;
  final Function() onHabitCreated; // Callback для обновления родительского виджета

  const HabitCreationArea({
    super.key,
    required this.apiManager,
    required this.onHabitCreated,
  });

  @override
  State<HabitCreationArea> createState() => _HabitCreationAreaState();
}

class _HabitCreationAreaState extends State<HabitCreationArea> {
  bool _isCreatingCustomHabit = false;
  HabitTemplate? _selectedTemplate;
  bool _isSaving = false;

  void _handleTemplateSelected(HabitTemplate template) {
    setState(() {
      _selectedTemplate = template;
      _isCreatingCustomHabit = false;
    });
  }

  Future<void> _handleHabitSaved(HabitSettings settings) async {
    setState(() {
      _isSaving = true;
    });

    try {
      final success = await HabitService.saveNewHabit(
        settings,
        widget.apiManager,
      );

      if (success) {
        // Показываем уведомление об успехе
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Привычка успешно создана!'),
              backgroundColor: Colors.green,
            ),
          );
        }

        // Вызываем callback для обновления родительского виджета
        widget.onHabitCreated();

        // Переходим на страницу привычек
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/habits');
        }
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
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Container(
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
          if (_isSaving)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
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