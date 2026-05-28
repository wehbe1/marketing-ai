import 'package:flutter/material.dart';
import '../localization/strings.dart';

class CurrentMarketingSection extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final ValueChanged<Map<String, dynamic>> onChanged;
  final AppStrings strings;

  const CurrentMarketingSection({
    super.key,
    required this.initialData,
    required this.onChanged,
    required this.strings,
  });

  @override
  State<CurrentMarketingSection> createState() =>
      _CurrentMarketingSectionState();
}

class _CurrentMarketingSectionState extends State<CurrentMarketingSection> {
  List<String> _selectedPlatforms = [];
  late TextEditingController _frequencyController;
  bool _hasPaidAds = false;
  bool _hasWebsite = false;

  // נשמור מפתחות קבועים באנגלית ונציג טקסט לפי שפה
  final List<String> _allPlatforms = [
    'facebook',
    'instagram',
    'tiktok',
    'google',
    'email',
    'none',
  ];

  @override
  void initState() {
    super.initState();
    _selectedPlatforms = List<String>.from(
      widget.initialData['platforms'] ?? [],
    );
    _frequencyController = TextEditingController(
      text: widget.initialData['frequency'] ?? '',
    );
    _hasPaidAds = widget.initialData['has_paid_ads'] ?? false;
    _hasWebsite = widget.initialData['has_website'] ?? false;
  }

  void _notifyParent() {
    widget.onChanged({
      "platforms": _selectedPlatforms,
      "frequency": _frequencyController.text.trim(),
      "has_paid_ads": _hasPaidAds,
      "has_website": _hasWebsite,
    });
  }

  @override
  void dispose() {
    _frequencyController.dispose();
    super.dispose();
  }

  String _platformLabel(String key) {
    final s = widget.strings;
    switch (key) {
      case 'facebook':
        return s.platformFacebook;
      case 'instagram':
        return s.platformInstagram;
      case 'tiktok':
        return s.platformTikTok;
      case 'google':
        return s.platformGoogle;
      case 'email':
        return s.platformEmail;
      case 'none':
      default:
        return s.platformNoMarketing;
    }
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
              s.sectionCurrentMarketingTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),
            Text(s.currentWhereAdvertiseLabel),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  _allPlatforms.map((platformKey) {
                    final isSelected = _selectedPlatforms.contains(platformKey);
                    return FilterChip(
                      label: Text(_platformLabel(platformKey)),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedPlatforms.add(platformKey);
                          } else {
                            _selectedPlatforms.remove(platformKey);
                          }
                        });
                        _notifyParent();
                      },
                    );
                  }).toList(),
            ),

            const SizedBox(height: 16),
            TextField(
              controller: _frequencyController,
              decoration: InputDecoration(labelText: s.currentFrequencyLabel),
              onChanged: (_) => _notifyParent(),
            ),

            const SizedBox(height: 16),
            Text(s.currentPaidCampaignsQuestion),
            RadioListTile<bool>(
              title: Text(s.yes),
              value: true,
              groupValue: _hasPaidAds,
              onChanged: (value) {
                setState(() {
                  _hasPaidAds = value!;
                });
                _notifyParent();
              },
            ),
            RadioListTile<bool>(
              title: Text(s.no),
              value: false,
              groupValue: _hasPaidAds,
              onChanged: (value) {
                setState(() {
                  _hasPaidAds = value!;
                });
                _notifyParent();
              },
            ),

            const SizedBox(height: 16),
            Text(s.currentWebsiteQuestion),
            RadioListTile<bool>(
              title: Text(s.yes),
              value: true,
              groupValue: _hasWebsite,
              onChanged: (value) {
                setState(() {
                  _hasWebsite = value!;
                });
                _notifyParent();
              },
            ),
            RadioListTile<bool>(
              title: Text(s.no),
              value: false,
              groupValue: _hasWebsite,
              onChanged: (value) {
                setState(() {
                  _hasWebsite = value!;
                });
                _notifyParent();
              },
            ),
          ],
        ),
      ),
    );
  }
}
