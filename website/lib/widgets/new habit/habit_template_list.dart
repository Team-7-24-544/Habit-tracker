import 'package:flutter/material.dart';
import 'package:website/models/MetaInfo.dart';
import 'package:website/services/api_manager.dart';
import 'package:website/services/api_query.dart';
import '../../models/habit_template.dart';

class HabitTemplateList extends StatefulWidget {
  final Function(HabitTemplate) onTemplateSelected;
  List<HabitTemplate> templates = [];

  HabitTemplateList({
    super.key,
    required this.onTemplateSelected,
  });

  @override
  _HabitTemplateListState createState() => _HabitTemplateListState();
}

class _HabitTemplateListState extends State<HabitTemplateList> {
  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  Future<void> _loadTemplates() async {
    List<HabitTemplate> loadedTemplates = [];

    ApiQuery query = ApiQueryBuilder().path(QueryPaths.getTemplateHabits).build();
    ApiResponse response = await MetaInfo.getApiManager().get(query);

    if (!response.success) return;

    Map<String, dynamic> habits = response.body["body"];
    for (var id in habits.keys) {
      loadedTemplates.add(HabitTemplate(
        id: id,
        name: habits[id]["name"],
        description: habits[id]["description"],
        timeTable: habits[id]["time_table"].toString(),
      ));
    }

    setState(() {
      widget.templates = loadedTemplates;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.templates.map((template) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.fitness_center),
            title: Text(template.name),
            subtitle: Text(template.description),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => widget.onTemplateSelected(template),
          ),
        );
      }).toList(),
    );
  }
}
