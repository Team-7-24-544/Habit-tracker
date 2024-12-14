import 'package:flutter/material.dart';

class HabitSettings {
  final String name;
  final String description;
  final TimeOfDay timeOfDay;
  final List<bool> weekDays;
  final int durationInDays;
  final int repetitionsPerDay;
  final Map<String, dynamic> additionalSettings;

  HabitSettings({
    required this.name,
    required this.description,
    required this.timeOfDay,
    List<bool>? weekDays,
    this.durationInDays = 30,
    this.repetitionsPerDay = 1,
    Map<String, dynamic>? additionalSettings,
  }) : 
    weekDays = weekDays ?? List.filled(7, true),
    additionalSettings = additionalSettings ?? {};
}