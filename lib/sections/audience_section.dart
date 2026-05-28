import 'package:flutter/material.dart';
import '../localization/strings.dart';

class AudienceSection extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final ValueChanged<Map<String, dynamic>> onChanged;
  final AppStrings strings;

  const AudienceSection({
    super.key,
    required this.initialData,
    required this.onChanged,
    required this.strings,
  });

  @override
  State<AudienceSection> createState() => _AudienceSectionState();
}

class _AudienceSectionState extends State<AudienceSection> {
  late TextEditingController _ageRangeController;
  late TextEditingController _locationController;
  late TextEditingController _interestsController;
  late TextEditingController _painPointsController;
  late TextEditingController _buyingTriggersController;

  @override
  void initState() {
    super.initState();
    _ageRangeController = TextEditingController(
      text: widget.initialData['age_range'] ?? '',
    );
    _locationController = TextEditingController(
      text: widget.initialData['location'] ?? '',
    );
    _interestsController = TextEditingController(
      text: widget.initialData['interests'] ?? '',
    );
    _painPointsController = TextEditingController(
      text: widget.initialData['pain_points'] ?? '',
    );
    _buyingTriggersController = TextEditingController(
      text: widget.initialData['buying_triggers'] ?? '',
    );
  }

  void _notifyParent() {
    widget.onChanged({
      "age_range": _ageRangeController.text.trim(),
      "location": _locationController.text.trim(),
      "interests": _interestsController.text.trim(),
      "pain_points": _painPointsController.text.trim(),
      "buying_triggers": _buyingTriggersController.text.trim(),
    });
  }

  @override
  void dispose() {
    _ageRangeController.dispose();
    _locationController.dispose();
    _interestsController.dispose();
    _painPointsController.dispose();
    _buyingTriggersController.dispose();
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
              s.sectionAudienceTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _ageRangeController,
              decoration: InputDecoration(labelText: s.audienceAgeLabel),
              onChanged: (_) => _notifyParent(),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: s.audienceLocationLabel),
              onChanged: (_) => _notifyParent(),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _interestsController,
              decoration: InputDecoration(labelText: s.audienceInterestsLabel),
              maxLines: 2,
              onChanged: (_) => _notifyParent(),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _painPointsController,
              decoration: InputDecoration(labelText: s.audiencePainPointsLabel),
              maxLines: 3,
              onChanged: (_) => _notifyParent(),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _buyingTriggersController,
              decoration: InputDecoration(
                labelText: s.audienceBuyingTriggersLabel,
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
