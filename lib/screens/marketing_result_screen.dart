import 'package:flutter/material.dart';

class MarketingResultScreen extends StatelessWidget {
  final Map<String, dynamic> analysisData;

  const MarketingResultScreen({super.key, required this.analysisData});

  List<String> _stringListFrom(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [value.toString()];
  }

  List<Map<String, dynamic>> _mapListFrom(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value
          .where((e) => e is Map)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    }
    return [];
  }

  Widget _buildCard(String title, Widget child) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildBullets(List<String> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((e) => Text('• $e')).toList(),
    );
  }

  Widget _buildSummaryCard() {
    final summary = analysisData['overall_summary']?.toString() ?? '';
    if (summary.isEmpty) return const SizedBox.shrink();

    return _buildCard('סיכום כללי', Text(summary));
  }

  Widget _buildStrengthsWeaknessesCard() {
    final strengths = _stringListFrom(analysisData['strengths']);
    final weaknesses = _stringListFrom(analysisData['weaknesses']);

    if (strengths.isEmpty && weaknesses.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildCard(
      'חוזקות וחולשות',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (strengths.isNotEmpty) ...[
            const Text(
              'חוזקות:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            _buildBullets(strengths),
            const SizedBox(height: 8),
          ],
          if (weaknesses.isNotEmpty) ...[
            const Text(
              'חולשות:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            _buildBullets(weaknesses),
          ],
        ],
      ),
    );
  }

  Widget _buildAudienceCard() {
    final audience = analysisData['audience_analysis'] as Map?;
    if (audience == null) return const SizedBox.shrink();

    return _buildCard(
      'קהל יעד',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (audience['who_they_are'] != null) ...[
            const Text('מי הם:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(audience['who_they_are'].toString()),
            const SizedBox(height: 8),
          ],
          if (audience['what_they_need'] != null) ...[
            const Text(
              'מה הם צריכים:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(audience['what_they_need'].toString()),
            const SizedBox(height: 8),
          ],
          if (audience['how_to_speak_to_them'] != null) ...[
            const Text(
              'איך לדבר אליהם:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(audience['how_to_speak_to_them'].toString()),
          ],
        ],
      ),
    );
  }

  Widget _buildPositioningCard() {
    final pos = analysisData['positioning'] as Map?;
    if (pos == null) return const SizedBox.shrink();

    final keyMessages = _stringListFrom(pos['key_messages']);

    return _buildCard(
      'מיתוג ומיצוב',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (pos['brand_position'] != null) ...[
            const Text(
              'עמדת המותג:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(pos['brand_position'].toString()),
            const SizedBox(height: 8),
          ],
          if (pos['unique_value_proposition'] != null) ...[
            const Text(
              'הצעת ערך ייחודית:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(pos['unique_value_proposition'].toString()),
            const SizedBox(height: 8),
          ],
          if (keyMessages.isNotEmpty) ...[
            const Text(
              'מסרים מרכזיים:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            _buildBullets(keyMessages),
          ],
        ],
      ),
    );
  }

  Widget _buildChannelsCard() {
    final channels = _mapListFrom(analysisData['recommended_channels']);
    if (channels.isEmpty) return const SizedBox.shrink();

    return _buildCard(
      'ערוצי שיווק מומלצים',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            channels.map((ch) {
              final channel = ch['channel']?.toString() ?? '';
              final priority = ch['priority']?.toString() ?? '';
              final reason = ch['reason']?.toString() ?? '';
              final usage = ch['suggested_usage']?.toString() ?? '';

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$channel (${priority.toUpperCase()})',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (reason.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text('למה: $reason'),
                    ],
                    if (usage.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text('איך להשתמש: $usage'),
                    ],
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildContentStrategyCard() {
    final content = analysisData['content_strategy'] as Map?;
    if (content == null) return const SizedBox.shrink();

    final themes = _stringListFrom(content['content_themes']);
    final postIdeas = _mapListFrom(content['post_ideas']);

    return _buildCard(
      'אסטרטגיית תוכן ורעיונות לפוסטים',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (content['tone_of_voice'] != null) ...[
            const Text(
              'טון דיבור:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(content['tone_of_voice'].toString()),
            const SizedBox(height: 8),
          ],
          if (themes.isNotEmpty) ...[
            const Text(
              'תמות תוכן:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            _buildBullets(themes),
            const SizedBox(height: 12),
          ],
          if (postIdeas.isNotEmpty) ...[
            const Text(
              'רעיונות לפוסטים:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            ...postIdeas.map((idea) {
              final channel = idea['channel']?.toString() ?? '';
              final summary = idea['idea_summary']?.toString() ?? '';
              final hook = idea['hook']?.toString() ?? '';
              final cta = idea['call_to_action']?.toString() ?? '';

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      channel,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (summary.isNotEmpty) Text('רעיון: $summary'),
                    if (hook.isNotEmpty) Text('Hook: $hook'),
                    if (cta.isNotEmpty) Text('CTA: $cta'),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildWeeklyPlanCard() {
    final weeks = _mapListFrom(analysisData['weekly_plan']);
    if (weeks.isEmpty) return const SizedBox.shrink();

    return _buildCard(
      'תכנית שבועית',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            weeks.asMap().entries.map((entry) {
              final index = entry.key + 1;
              final week = entry.value;
              final goal = week['week_goal']?.toString() ?? '';
              final actions = _stringListFrom(week['actions']);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'שבוע $index – מטרה:',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (goal.isNotEmpty) Text(goal),
                    if (actions.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      const Text(
                        'צעדים:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      _buildBullets(actions),
                    ],
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildKpisAndRisksCard() {
    final kpis = _stringListFrom(analysisData['kpis']);
    final risks = _stringListFrom(analysisData['risks_and_warnings']);
    final budget = analysisData['budget_recommendation']?.toString() ?? '';

    if (kpis.isEmpty && risks.isEmpty && budget.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildCard(
      'מדדי הצלחה וסיכונים',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (budget.isNotEmpty) ...[
            const Text(
              'המלצת תקציב:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(budget),
            const SizedBox(height: 12),
          ],
          if (kpis.isNotEmpty) ...[
            const Text(
              'KPI – מה למדוד:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            _buildBullets(kpis),
            const SizedBox(height: 12),
          ],
          if (risks.isNotEmpty) ...[
            const Text(
              'סיכונים ואזהרות:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            _buildBullets(risks),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('תוכנית השיווק החכמה')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSummaryCard(),
            _buildStrengthsWeaknessesCard(),
            _buildAudienceCard(),
            _buildPositioningCard(),
            _buildChannelsCard(),
            _buildContentStrategyCard(),
            _buildWeeklyPlanCard(),
            _buildKpisAndRisksCard(),
            const SizedBox(height: 16),
            const PostGeneratorCard(),
          ],
        ),
      ),
    );
  }
}

class PostGeneratorCard extends StatefulWidget {
  const PostGeneratorCard({super.key});

  @override
  State<PostGeneratorCard> createState() => _PostGeneratorCardState();
}

class _PostGeneratorCardState extends State<PostGeneratorCard> {
  final TextEditingController _topicController = TextEditingController();

  String _channel = 'אינסטגרם';
  String _postType = 'השראה';
  String _tone = 'קליל';
  String _length = 'בינוני';

  String _generatedPost = '';

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  void _generateDummyPost() {
    final topic = _topicController.text.trim();

    if (topic.isEmpty) {
      setState(() {
        _generatedPost = 'כדי ליצור פוסט, רשום קודם נושא בחלון למעלה 🙂';
      });
      return;
    }

    // כרגע: טיוטה מקומית. בהמשך נחליף בקריאה ל-API.
    setState(() {
      _generatedPost = '''
פלטפורמה: $_channel
סוג פוסט: $_postType
טון דיבור: $_tone
אורך: $_length

טיוטת פוסט על "$topic":

כאן בהמשך נציג את הפוסט האמיתי שנקבל מ-AI.
בינתיים זה רק מקום־מחזיק (placeholder) כדי לראות שה-UI עובד.
''';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'מחולל פוסטים חכם',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            const Text('נושא הפוסט (מה המסר המרכזי?):'),
            const SizedBox(height: 4),
            TextField(
              controller: _topicController,
              textDirection: TextDirection.rtl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'למשל: בית קפה לעבודה עם קפה ספיישלטי ומאפים טריים',
              ),
              maxLines: 2,
            ),

            const SizedBox(height: 12),

            // שורה של בחירות
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: 'פלטפורמה',
                    value: _channel,
                    items: const ['אינסטגרם', 'פייסבוק'],
                    onChanged: (v) {
                      if (v != null) {
                        setState(() => _channel = v);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDropdown(
                    label: 'סוג פוסט',
                    value: _postType,
                    items: const [
                      'השראה',
                      'מכירתי',
                      'מאחורי הקלעים',
                      'סיפור אישי',
                      'מבצע',
                      'מוצר חדש',
                    ],
                    onChanged: (v) {
                      if (v != null) {
                        setState(() => _postType = v);
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: 'טון דיבור',
                    value: _tone,
                    items: const ['קליל', 'מקצועי', 'רגשי', 'מצחיק'],
                    onChanged: (v) {
                      if (v != null) {
                        setState(() => _tone = v);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDropdown(
                    label: 'אורך',
                    value: _length,
                    items: const ['קצר', 'בינוני', 'ארוך'],
                    onChanged: (v) {
                      if (v != null) {
                        setState(() => _length = v);
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _generateDummyPost,
                child: const Text('צור טיוטת פוסט'),
              ),
            ),

            const SizedBox(height: 16),

            if (_generatedPost.isNotEmpty) ...[
              const Text(
                'טיוטת פוסט:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFFF3F0FF),
                ),
                padding: const EdgeInsets.all(12),
                child: SelectableText(
                  _generatedPost,
                  textDirection: TextDirection.rtl,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items:
              items
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
