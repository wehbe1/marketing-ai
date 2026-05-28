import 'package:flutter/material.dart';
import '../sections/business_header_section.dart';
import '../sections/audience_section.dart';
import '../sections/current_marketing_section.dart';
import '../sections/goals_section.dart';
import '../sections/competition_section.dart';
import '../sections/constraints_section.dart';
import '../services/marketing_api.dart';
import '../localization/app_language.dart';
import '../localization/strings.dart';
import 'post_generator_screen.dart';

class ReportCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const ReportCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header עם גרדיאנט
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF5B8CFF), // כחול
                  Color(0xFF9B5BFF), // סגול
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // תוכן
          Padding(padding: const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }
}

// מחירים – כרגע רק להדגמה
const double singleReportPriceNis = 49; // דו"ח אחד
const double tripleReportPriceNis = 119; // חבילת 3 דוחות (לעתיד)

// נתונים גלובליים (אפשר להעביר למודל בעתיד)
Map<String, dynamic> currentMarketingData = {};
Map<String, dynamic> goalsData = {};
Map<String, dynamic> competitionData = {};
Map<String, dynamic> constraintsData = {};

class MarketingPlanScreen extends StatefulWidget {
  final AppLanguage language;

  const MarketingPlanScreen({super.key, required this.language});

  @override
  State<MarketingPlanScreen> createState() => _MarketingPlanScreenState();
}

class _MarketingPlanScreenState extends State<MarketingPlanScreen> {
  Map<String, dynamic> businessData = {};
  Map<String, dynamic> audienceData = {};

  bool _isLoading = false;
  Map<String, dynamic> analysisData = {};

  // מיקוד יעד (goal_focus ל־backend)
  String _goalFocus = 'new_customers'; // ברירת מחדל: לקוחות חדשים

  // האם הדוח המלא פתוח או נעול
  bool _isFullReportUnlocked = false;

  late final AppStrings strings;

  @override
  void initState() {
    super.initState();
    strings = AppStrings(widget.language);
  }

  // -----------------------------
  //   עזר להמרות בטוחות
  // -----------------------------
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

  // -----------------------------
  //   בניית JSON לשליחה לשרת
  // -----------------------------
  Map<String, dynamic> buildMarketingJson() {
    return {
      "business": businessData,
      "audience": audienceData,
      "current_marketing": currentMarketingData,
      "goals": goalsData,
      "competition": competitionData,
      "constraints": constraintsData,
      "goal_focus": _goalFocus,
    };
  }

  // -----------------------------
  //   קריאה ל-API
  // -----------------------------
  Future<void> _onAnalyzePressed() async {
    final payload = buildMarketingJson();

    setState(() {
      _isLoading = true;
      _isFullReportUnlocked = false; // כל ניתוח חדש מתחיל נעול
    });

    try {
      final result = await MarketingApi.analyzeMarketing(payload);
      debugPrint('ANALYSIS JSON: $result');

      setState(() {
        analysisData = result;
      });
    } catch (e) {
      debugPrint('Error while calling API: $e');
      // אפשר להוסיף SnackBar בהמשך
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // -----------------------------
  //   וידג'ט בסיסי לכרטיס
  // -----------------------------
  Widget _buildCard(String title, IconData icon, Widget child) {
    return ReportCard(title: title, icon: icon, child: child);
  }

  Widget _buildLockedReportCard() {
    return Card(
      margin: const EdgeInsets.only(top: 16),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // כותרת
            Text(
              strings.paywallTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // טקסט הסבר
            Text(strings.paywallDescription),

            const SizedBox(height: 16),

            // תמחור
            Text(
              strings.paywallPricingTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '${strings.paywallSinglePrefix} ₪${singleReportPriceNis.toStringAsFixed(0)}',
            ),
            Text(
              '${strings.paywallBundlePrefix} ₪${tripleReportPriceNis.toStringAsFixed(0)}',
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // כרגע: סימולציה – בעתיד כאן נבצע תשלום אמיתי
                    setState(() {
                      _isFullReportUnlocked = true;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(strings.paywallSnackFullOpened)),
                    );
                  },
                  child: Text(
                    '${strings.paywallPrimaryButton} '
                    '(₪${singleReportPriceNis.toStringAsFixed(0)})',
                  ),
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isFullReportUnlocked = true;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(strings.paywallSnackBundleOpened)),
                    );
                  },
                  child: Text(
                    '${strings.paywallBundleButton} – '
                    '₪${tripleReportPriceNis.toStringAsFixed(0)}',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // הערת דמו
            Text(
              strings.paywallDemoNote,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
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

  // -----------------------------
  //   כרטיסים לפי חלקי הניתוח
  // -----------------------------
  Widget _buildSummaryCard() {
    final summary = analysisData['overall_summary']?.toString() ?? '';
    if (summary.isEmpty) return const SizedBox.shrink();

    return _buildCard(
      strings.analysisSummaryTitle,
      Icons.insights,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(summary, style: const TextStyle(fontSize: 14, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildStrengthsWeaknessesCard() {
    final strengths = _stringListFrom(analysisData['strengths']);
    final weaknesses = _stringListFrom(analysisData['weaknesses']);

    if (strengths.isEmpty && weaknesses.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildCard(
      strings.analysisStrengthsWeaknessesTitle,
      Icons.balance,
      LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 600;

          Widget strengthsColumn = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.analysisStrengthsLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E8E3E),
                ),
              ),
              const SizedBox(height: 6),
              ...strengths.map(
                (e) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '✔ ',
                      style: TextStyle(color: Color(0xFF1E8E3E)),
                    ),
                    Expanded(child: Text(e)),
                  ],
                ),
              ),
            ],
          );

          Widget weaknessesColumn = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.analysisWeaknessesLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD93025),
                ),
              ),
              const SizedBox(height: 6),
              ...weaknesses.map(
                (e) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '⚠ ',
                      style: TextStyle(color: Color(0xFFD93025)),
                    ),
                    Expanded(child: Text(e)),
                  ],
                ),
              ),
            ],
          );

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (strengths.isNotEmpty) strengthsColumn,
                if (strengths.isNotEmpty && weaknesses.isNotEmpty)
                  const SizedBox(height: 12),
                if (weaknesses.isNotEmpty) weaknessesColumn,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (strengths.isNotEmpty) Expanded(child: strengthsColumn),
              if (strengths.isNotEmpty && weaknesses.isNotEmpty)
                Container(
                  height: 80,
                  width: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  color: Colors.grey.shade300,
                ),
              if (weaknesses.isNotEmpty) Expanded(child: weaknessesColumn),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAudienceCard() {
    final audience = analysisData['audience_analysis'] as Map?;
    if (audience == null) return const SizedBox.shrink();

    return _buildCard(
      strings.analysisAudienceTitle,
      Icons.group,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (audience['who_they_are'] != null) ...[
            Text(
              strings.analysisAudienceWhoLabel,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(audience['who_they_are'].toString()),
            const SizedBox(height: 8),
          ],
          if (audience['what_they_need'] != null) ...[
            Text(
              strings.analysisAudienceNeedLabel,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(audience['what_they_need'].toString()),
            const SizedBox(height: 8),
          ],
          if (audience['how_to_speak_to_them'] != null) ...[
            Text(
              strings.analysisAudienceHowSpeakLabel,
              style: const TextStyle(fontWeight: FontWeight.bold),
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
      strings.analysisPositioningTitle,
      Icons.flag,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (pos['brand_position'] != null) ...[
            Text(
              strings.analysisBrandPositionLabel,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(pos['brand_position'].toString()),
            const SizedBox(height: 8),
          ],
          if (pos['unique_value_proposition'] != null) ...[
            Text(
              strings.analysisUniqueValueLabel,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(pos['unique_value_proposition'].toString()),
            const SizedBox(height: 8),
          ],
          if (keyMessages.isNotEmpty) ...[
            Text(
              strings.analysisKeyMessagesLabel,
              style: const TextStyle(fontWeight: FontWeight.bold),
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
      strings.analysisChannelsTitle,
      Icons.campaign,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            channels.map((ch) {
              final channel = ch['channel']?.toString() ?? '';
              final priority = ch['priority']?.toString() ?? '';
              final reason = ch['reason']?.toString() ?? '';
              final usage = ch['suggested_usage']?.toString() ?? '';

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Chip(
                          label: Text(channel),
                          backgroundColor: const Color(0xFFE8F0FF),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          priority.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    if (reason.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text('${strings.analysisChannelReasonLabel} $reason'),
                    ],
                    if (usage.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text('${strings.analysisChannelUsageLabel} $usage'),
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
      strings.analysisContentStrategyTitle,
      Icons.edit_note,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (content['tone_of_voice'] != null) ...[
            Text(
              strings.analysisToneLabel,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(content['tone_of_voice'].toString()),
            const SizedBox(height: 8),
          ],
          if (themes.isNotEmpty) ...[
            Text(
              strings.analysisThemesLabel,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            _buildBullets(themes),
            const SizedBox(height: 12),
          ],
          if (postIdeas.isNotEmpty) ...[
            Text(
              strings.analysisPostIdeasTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
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
                    if (summary.isNotEmpty)
                      Text('${strings.analysisPostIdeaLabel} $summary'),
                    if (hook.isNotEmpty)
                      Text('${strings.analysisPostHookLabel} $hook'),
                    if (cta.isNotEmpty)
                      Text('${strings.analysisPostCtaLabel} $cta'),
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
      strings.analysisWeeklyPlanTitle,
      Icons.timeline,
      Column(
        children:
            weeks.asMap().entries.map((entry) {
              final index = entry.key + 1;
              final week = entry.value;
              final goal = week['week_goal']?.toString() ?? '';
              final actions = _stringListFrom(week['actions']);

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // עמודת הטיימליין (עיגול + קו)
                  Column(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF5B8CFF), Color(0xFF9B5BFF)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '$index',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      if (index != weeks.length)
                        Container(
                          width: 2,
                          height: 40,
                          color: Colors.grey.shade300,
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),

                  // תוכן השבוע
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${strings.analysisWeekPrefix} $index – ${strings.analysisWeekGoalSuffix}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (goal.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(goal),
                          ],
                          if (actions.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              strings.analysisWeekActionsLabel,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  actions
                                      .map(
                                        (a) => Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text('• '),
                                            Expanded(child: Text(a)),
                                          ],
                                        ),
                                      )
                                      .toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
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
      strings.analysisKpisAndRisksTitle,
      Icons.show_chart,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (budget.isNotEmpty) ...[
            Text(
              strings.analysisBudgetLabel,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(budget),
            const SizedBox(height: 12),
          ],
          if (kpis.isNotEmpty) ...[
            Text(
              strings.analysisKpisLabel,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            _buildBullets(kpis),
            const SizedBox(height: 12),
          ],
          if (risks.isNotEmpty) ...[
            Text(
              strings.analysisRisksLabel,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            _buildBullets(risks),
          ],
        ],
      ),
    );
  }

  // -----------------------------
  //   בניית כל הכרטיסים יחד
  // -----------------------------

  Widget _buildAnalysisView() {
    if (analysisData.isEmpty) return const SizedBox.shrink();

    // מה שהמשתמש רואה בחינם
    final freeCards = <Widget>[
      _buildSummaryCard(),
      _buildStrengthsWeaknessesCard(),
      _buildAudienceCard(),
    ];

    // מה שנעול עד פתיחה
    final lockedCards = <Widget>[
      _buildPositioningCard(),
      _buildChannelsCard(),
      _buildContentStrategyCard(),
      _buildWeeklyPlanCard(),
      _buildKpisAndRisksCard(),
    ];

    return Column(
      children: [
        // חינמי – תמיד
        ...freeCards.where((w) => w is! SizedBox),

        // אם עדיין נעול – כרטיס Paywall
        if (!_isFullReportUnlocked) _buildLockedReportCard(),

        // אם נפתח – הצגת שאר הכרטיסים
        if (_isFullReportUnlocked) ...lockedCards.where((w) => w is! SizedBox),
      ],
    );
  }

  // -----------------------------
  //   BUILD
  // -----------------------------
  @override
  Widget build(BuildContext context) {
    final textDirection =
        (widget.language == AppLanguage.en)
            ? TextDirection.ltr
            : TextDirection.rtl;

    return Directionality(
      textDirection: textDirection,
      child: Scaffold(
        appBar: AppBar(title: Text(strings.appTitle)),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // --- סקשנים של הטופס ---
            BusinessHeaderSection(
              strings: strings,
              initialData: businessData,
              onChanged: (data) {
                setState(() => businessData = data);
              },
            ),
            const SizedBox(height: 16),

            AudienceSection(
              strings: strings,
              initialData: audienceData,
              onChanged: (data) {
                setState(() => audienceData = data);
              },
            ),
            const SizedBox(height: 16),

            CurrentMarketingSection(
              strings: strings,
              initialData: currentMarketingData,
              onChanged: (data) {
                setState(() => currentMarketingData = data);
              },
            ),
            const SizedBox(height: 16),

            GoalsSection(
              strings: strings,
              initialData: goalsData,
              onChanged: (data) {
                setState(() => goalsData = data);
              },
            ),
            const SizedBox(height: 16),

            CompetitionSection(
              strings: strings,
              initialData: competitionData,
              onChanged: (data) {
                setState(() => competitionData = data);
              },
            ),
            const SizedBox(height: 16),

            ConstraintsSection(
              strings: strings,
              initialData: constraintsData,
              onChanged: (data) {
                setState(() => constraintsData = data);
              },
            ),

            const SizedBox(height: 24),

            // --- בחירת מטרה ---
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.goalQuestionTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _goalFocus,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: strings.goalDropdownLabel,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'new_customers',
                          child: Text(strings.goalNewCustomers),
                        ),
                        DropdownMenuItem(
                          value: 'retention',
                          child: Text(strings.goalRetention),
                        ),
                        DropdownMenuItem(
                          value: 'upsell',
                          child: Text(strings.goalUpsell),
                        ),
                      ],

                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _goalFocus = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // --- כפתור יצירת תוכנית ---
            ElevatedButton(
              onPressed: _isLoading ? null : _onAnalyzePressed,
              child:
                  _isLoading
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : Text(strings.generatePlanButton),
            ),

            const SizedBox(height: 16),

            // כפתור מעבר למחולל פוסטים
            ElevatedButton.icon(
              icon: const Icon(Icons.post_add),
              label: Text(strings.generatePostButton),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => PostGeneratorScreen(language: widget.language),
                  ),
                );
              },
            ),

            _buildAnalysisView(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
