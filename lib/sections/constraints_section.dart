import 'package:flutter/material.dart';
import '../localization/strings.dart';

class ConstraintsSection extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final ValueChanged<Map<String, dynamic>> onChanged;
  final AppStrings strings;

  const ConstraintsSection({
    super.key,
    required this.initialData,
    required this.onChanged,
    required this.strings,
  });

  @override
  State<ConstraintsSection> createState() => _ConstraintsSectionState();
}

class _ConstraintsSectionState extends State<ConstraintsSection> {
  late TextEditingController _budgetController;
  late TextEditingController _timePerWeekController;
  late TextEditingController _resourcesController;

  @override
  void initState() {
    super.initState();
    _budgetController = TextEditingController(
      text: widget.initialData['budget'] ?? '',
    );
    _timePerWeekController = TextEditingController(
      text: widget.initialData['time_per_week'] ?? '',
    );
    _resourcesController = TextEditingController(
      text: widget.initialData['resources_limitations'] ?? '',
    );
  }

  void _notifyParent() {
    widget.onChanged({
      "budget": _budgetController.text.trim(),
      "time_per_week": _timePerWeekController.text.trim(),
      "resources_limitations": _resourcesController.text.trim(),
    });
  }

  @override
  void dispose() {
    _budgetController.dispose();
    _timePerWeekController.dispose();
    _resourcesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.strings;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s.sectionConstraintsTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: _budgetController,
              decoration: InputDecoration(labelText: s.constraintsBudgetLabel),
              keyboardType: TextInputType.number,
              onChanged: (_) => _notifyParent(),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _timePerWeekController,
              decoration: InputDecoration(
                labelText: s.constraintsTimePerWeekLabel,
              ),
              onChanged: (_) => _notifyParent(),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _resourcesController,
              decoration: InputDecoration(
                labelText: s.constraintsResourcesLabel,
              ),
              maxLines: 2,
              onChanged: (_) => _notifyParent(),
            ),
          ],
        ),
      ),
    );
  }
}
