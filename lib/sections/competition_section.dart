import 'package:flutter/material.dart';
import '../localization/strings.dart';

class CompetitionSection extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final ValueChanged<Map<String, dynamic>> onChanged;
  final AppStrings strings;

  const CompetitionSection({
    super.key,
    required this.initialData,
    required this.onChanged,
    required this.strings,
  });

  @override
  State<CompetitionSection> createState() => _CompetitionSectionState();
}

class _CompetitionSectionState extends State<CompetitionSection> {
  String _competitionLevel = 'medium';
  late TextEditingController _competitorsController;
  late TextEditingController _strengthsController;
  late TextEditingController _weaknessesController;

  @override
  void initState() {
    super.initState();
    _competitionLevel = widget.initialData['competition_level'] ?? 'medium';
    _competitorsController = TextEditingController(
      text: widget.initialData['competitors'] ?? '',
    );
    _strengthsController = TextEditingController(
      text: widget.initialData['strengths'] ?? '',
    );
    _weaknessesController = TextEditingController(
      text: widget.initialData['weaknesses'] ?? '',
    );
  }

  void _notifyParent() {
    widget.onChanged({
      "competition_level": _competitionLevel, // low/medium/high
      "competitors": _competitorsController.text.trim(),
      "strengths": _strengthsController.text.trim(),
      "weaknesses": _weaknessesController.text.trim(),
    });
  }

  @override
  void dispose() {
    _competitorsController.dispose();
    _strengthsController.dispose();
    _weaknessesController.dispose();
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
              s.sectionCompetitionTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Text(s.competitionLevelLabel),
            DropdownButton<String>(
              value: _competitionLevel,
              items: [
                DropdownMenuItem(
                  value: 'low',
                  child: Text(s.competitionLevelLow),
                ),
                DropdownMenuItem(
                  value: 'medium',
                  child: Text(s.competitionLevelMedium),
                ),
                DropdownMenuItem(
                  value: 'high',
                  child: Text(s.competitionLevelHigh),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _competitionLevel = value;
                });
                _notifyParent();
              },
            ),

            const SizedBox(height: 12),
            TextField(
              controller: _competitorsController,
              decoration: InputDecoration(
                labelText: s.competitionCompetitorsLabel,
              ),
              maxLines: 2,
              onChanged: (_) => _notifyParent(),
            ),

            const SizedBox(height: 12),
            TextField(
              controller: _strengthsController,
              decoration: InputDecoration(
                labelText: s.competitionStrengthsLabel,
              ),
              maxLines: 2,
              onChanged: (_) => _notifyParent(),
            ),

            const SizedBox(height: 12),
            TextField(
              controller: _weaknessesController,
              decoration: InputDecoration(
                labelText: s.competitionWeaknessesLabel,
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
