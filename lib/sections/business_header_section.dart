import 'package:flutter/material.dart';
import '../localization/strings.dart';

class BusinessHeaderSection extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final ValueChanged<Map<String, dynamic>> onChanged;
  final AppStrings strings;

  const BusinessHeaderSection({
    super.key,
    required this.initialData,
    required this.onChanged,
    required this.strings,
  });

  @override
  State<BusinessHeaderSection> createState() => _BusinessHeaderSectionState();
}

class _BusinessHeaderSectionState extends State<BusinessHeaderSection> {
  late TextEditingController _nameController;
  late TextEditingController _industryController;
  late TextEditingController _descriptionController;
  String _offerType = 'service'; // product / service / both (מאחסן באנגלית)

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialData['business_name'] ?? '',
    );
    _industryController = TextEditingController(
      text: widget.initialData['industry'] ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.initialData['description'] ?? '',
    );
    _offerType = widget.initialData['offer_type'] ?? 'service';
  }

  void _notifyParent() {
    widget.onChanged({
      "business_name": _nameController.text.trim(),
      "industry": _industryController.text.trim(),
      "description": _descriptionController.text.trim(),
      "offer_type": _offerType, // product / service / both
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _industryController.dispose();
    _descriptionController.dispose();
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
              s.sectionBusinessTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: s.businessNameLabel),
              onChanged: (_) => _notifyParent(),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _industryController,
              decoration: InputDecoration(labelText: s.businessIndustryLabel),
              onChanged: (_) => _notifyParent(),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: s.businessDescriptionLabel,
              ),
              maxLines: 3,
              onChanged: (_) => _notifyParent(),
            ),
            const SizedBox(height: 8),
            Text(s.businessOfferQuestion),
            DropdownButton<String>(
              value: _offerType,
              items: [
                DropdownMenuItem(
                  value: 'product',
                  child: Text(s.businessOfferProduct),
                ),
                DropdownMenuItem(
                  value: 'service',
                  child: Text(s.businessOfferService),
                ),
                DropdownMenuItem(
                  value: 'both',
                  child: Text(s.businessOfferBoth),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _offerType = value;
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
