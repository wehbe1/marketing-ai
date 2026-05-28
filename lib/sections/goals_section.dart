import 'package:flutter/material.dart';
import '../localization/strings.dart';

class GoalsSection extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final ValueChanged<Map<String, dynamic>> onChanged;
  final AppStrings strings;

  const GoalsSection({
    super.key,
    required this.initialData,
    required this.onChanged,
    required this.strings,
  });

  @override
  State<GoalsSection> createState() => _GoalsSectionState();
}

class _GoalsSectionState extends State<GoalsSection> {
  late TextEditingController _shortTermController;
  late TextEditingController _longTermController;
  late TextEditingController _numericGoalController;

  @override
  void initState() {
    super.initState();
    _shortTermController = TextEditingController(
      text: widget.initialData['short_term'] ?? '',
    );
    _longTermController = TextEditingController(
      text: widget.initialData['long_term'] ?? '',
    );
    _numericGoalController = TextEditingController(
      text: widget.initialData['numeric_goal'] ?? '',
    );
  }

  void _notifyParent() {
    widget.onChanged({
      "short_term": _shortTermController.text.trim(),
      "long_term": _longTermController.text.trim(),
      "numeric_goal": _numericGoalController.text.trim(),
    });
  }

  @override
  void dispose() {
    _shortTermController.dispose();
    _longTermController.dispose();
    _numericGoalController.dispose();
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
              s.sectionGoalsTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _shortTermController,
              decoration: InputDecoration(labelText: s.goalsShortTermLabel),
              maxLines: 2,
              onChanged: (_) => _notifyParent(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _longTermController,
              decoration: InputDecoration(labelText: s.goalsLongTermLabel),
              maxLines: 2,
              onChanged: (_) => _notifyParent(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _numericGoalController,
              decoration: InputDecoration(labelText: s.goalsNumericGoalLabel),
              keyboardType: TextInputType.number,
              onChanged: (_) => _notifyParent(),
            ),
          ],
        ),
      ),
    );
  }
}
