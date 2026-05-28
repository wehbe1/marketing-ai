import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_colors.dart';
import '../localization/app_language.dart';
import '../localization/strings.dart';
import '../widgets/premium_result_ui.dart';

class MarketingResultScreen extends StatefulWidget {
  final Map<String, dynamic> analysisData;

  const MarketingResultScreen({super.key, required this.analysisData});

  @override
  State<MarketingResultScreen> createState() => _MarketingResultScreenState();
}

class _MarketingResultScreenState extends State<MarketingResultScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final AppStrings _strings;

  Map<String, dynamic> get analysisData => widget.analysisData;

  @override
  void initState() {
    super.initState();
    _strings = AppStrings(AppLanguage.he);
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  String get _reportPlainText {
    final summary = analysisData['overall_summary']?.toString() ?? '';
    return summary.isNotEmpty ? summary : analysisData.toString();
  }

  void _copyReport() {
    Clipboard.setData(ClipboardData(text: _reportPlainText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_strings.postResultCopied),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _soon(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

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
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    return [];
  }

  // ── Section icon map ──────────────────────────────────────────────────────

  static const _sectionIcons = <String, IconData>{
    'סיכום כללי': Icons.summarize_rounded,
    'חוזקות וחולשות': Icons.balance_rounded,
    'קהל יעד': Icons.people_rounded,
    'מיתוג ומיצוב': Icons.auto_awesome_rounded,
    'ערוצי שיווק מומלצים': Icons.campaign_rounded,
    'אסטרטגיית תוכן ורעיונות לפוסטים': Icons.edit_note_rounded,
    'תכנית שבועית': Icons.calendar_month_rounded,
    'מדדי הצלחה וסיכונים': Icons.bar_chart_rounded,
  };

  static const _sectionColors = <String, Color>{
    'סיכום כללי': AppColors.primary,
    'חוזקות וחולשות': Color(0xFF10B981),
    'קהל יעד': Color(0xFFF59E0B),
    'מיתוג ומיצוב': AppColors.primaryDark,
    'ערוצי שיווק מומלצים': Color(0xFF3B82F6),
    'אסטרטגיית תוכן ורעיונות לפוסטים': Color(0xFF8B5CF6),
    'תכנית שבועית': Color(0xFF06B6D4),
    'מדדי הצלחה וסיכונים': Color(0xFFEF4444),
  };

  // ── Base card ─────────────────────────────────────────────────────────────

  Widget _buildCard(String title, Widget child, {String? copyText}) {
    final color = _sectionColors[title] ?? AppColors.primary;
    final icon = _sectionIcons[title] ?? Icons.article_rounded;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: Color(0x125B6EFF), blurRadius: 24, offset: Offset(0, 8)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.12),
                  color.withValues(alpha: 0.04),
                ],
              ),
              border: Border(
                bottom: BorderSide(color: color.withValues(alpha: 0.12)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withValues(alpha: 0.75)],
                    ),
                    borderRadius: BorderRadius.circular(11),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 17),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: color,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                if (copyText != null)
                  Material(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () => Clipboard.setData(ClipboardData(text: copyText)),
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(Icons.copy_rounded, size: 15, color: color),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
            child: child,
          ),
        ],
      ),
    );
  }

  // ── Bullet list ───────────────────────────────────────────────────────────

  Widget _buildBullets(List<String> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      e,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textDark,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  // ── Label + value row ─────────────────────────────────────────────────────

  Widget _buildLabelRow(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textMedium,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textDark,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }

  // ── Summary ───────────────────────────────────────────────────────────────

  Widget _buildSummaryCard() {
    final summary = analysisData['overall_summary']?.toString() ?? '';
    if (summary.isEmpty) return const SizedBox.shrink();

    return _buildCard(
      'סיכום כללי',
      ReadableContentText(
        text: summary,
        fontSize: 17,
        fontWeight: FontWeight.w500,
        height: 1.8,
      ),
      copyText: summary,
    );
  }

  // ── Strengths & weaknesses ────────────────────────────────────────────────

  Widget _buildStrengthsWeaknessesCard() {
    final strengths = _stringListFrom(analysisData['strengths']);
    final weaknesses = _stringListFrom(analysisData['weaknesses']);
    if (strengths.isEmpty && weaknesses.isEmpty) return const SizedBox.shrink();

    return _buildCard(
      'חוזקות וחולשות',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (strengths.isNotEmpty) ...[
            _buildSubLabel('חוזקות', const Color(0xFF10B981)),
            const SizedBox(height: 6),
            _buildBullets(strengths),
            const SizedBox(height: 14),
          ],
          if (weaknesses.isNotEmpty) ...[
            _buildSubLabel('חולשות', AppColors.error),
            const SizedBox(height: 6),
            _buildBullets(weaknesses),
          ],
        ],
      ),
    );
  }

  // ── Audience ──────────────────────────────────────────────────────────────

  Widget _buildAudienceCard() {
    final audience = analysisData['audience_analysis'] as Map?;
    if (audience == null) return const SizedBox.shrink();

    return _buildCard(
      'קהל יעד',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabelRow('מי הם', audience['who_they_are']?.toString() ?? ''),
          _buildLabelRow('מה הם צריכים', audience['what_they_need']?.toString() ?? ''),
          _buildLabelRow('איך לדבר אליהם', audience['how_to_speak_to_them']?.toString() ?? ''),
        ],
      ),
    );
  }

  // ── Positioning ───────────────────────────────────────────────────────────

  Widget _buildPositioningCard() {
    final pos = analysisData['positioning'] as Map?;
    if (pos == null) return const SizedBox.shrink();

    final keyMessages = _stringListFrom(pos['key_messages']);

    return _buildCard(
      'מיתוג ומיצוב',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabelRow('עמדת המותג', pos['brand_position']?.toString() ?? ''),
          _buildLabelRow('הצעת ערך ייחודית', pos['unique_value_proposition']?.toString() ?? ''),
          if (keyMessages.isNotEmpty) ...[
            _buildSubLabel('מסרים מרכזיים', AppColors.primaryDark),
            const SizedBox(height: 6),
            _buildBullets(keyMessages),
          ],
        ],
      ),
    );
  }

  // ── Channels ──────────────────────────────────────────────────────────────

  Widget _buildChannelsCard() {
    final channels = _mapListFrom(analysisData['recommended_channels']);
    if (channels.isEmpty) return const SizedBox.shrink();

    return _buildCard(
      'ערוצי שיווק מומלצים',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: channels.map((ch) {
          final channel = ch['channel']?.toString() ?? '';
          final priority = ch['priority']?.toString() ?? '';
          final reason = ch['reason']?.toString() ?? '';
          final usage = ch['suggested_usage']?.toString() ?? '';

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        channel,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    if (priority.isNotEmpty)
                      _PriorityBadge(priority: priority),
                  ],
                ),
                if (reason.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildLabelRow('למה', reason),
                ],
                if (usage.isNotEmpty)
                  _buildLabelRow('איך להשתמש', usage),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Content strategy ──────────────────────────────────────────────────────

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
          _buildLabelRow('טון דיבור', content['tone_of_voice']?.toString() ?? ''),
          if (themes.isNotEmpty) ...[
            _buildSubLabel('תמות תוכן', const Color(0xFF8B5CF6)),
            const SizedBox(height: 6),
            _buildBullets(themes),
            const SizedBox(height: 14),
          ],
          if (postIdeas.isNotEmpty) ...[
            _buildSubLabel('רעיונות לפוסטים', const Color(0xFF8B5CF6)),
            const SizedBox(height: 8),
            ...postIdeas.map((idea) {
              final channel = idea['channel']?.toString() ?? '';
              final summary = idea['idea_summary']?.toString() ?? '';
              final hook = idea['hook']?.toString() ?? '';
              final cta = idea['call_to_action']?.toString() ?? '';
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (channel.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          channel,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF8B5CF6),
                          ),
                        ),
                      ),
                    _buildLabelRow('רעיון', summary),
                    _buildLabelRow('Hook', hook),
                    _buildLabelRow('CTA', cta),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  // ── Weekly plan ───────────────────────────────────────────────────────────

  Widget _buildWeeklyPlanCard() {
    final weeks = _mapListFrom(analysisData['weekly_plan']);
    if (weeks.isEmpty) return const SizedBox.shrink();

    return _buildCard(
      'תכנית שבועית',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: weeks.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final week = entry.value;
          final goal = week['week_goal']?.toString() ?? '';
          final actions = _stringListFrom(week['actions']);

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        gradient: AppColors.gradient,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$index',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'שבוע $index',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ],
                ),
                if (goal.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildLabelRow('מטרה', goal),
                ],
                if (actions.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  _buildSubLabel('צעדים', const Color(0xFF06B6D4)),
                  const SizedBox(height: 6),
                  _buildBullets(actions),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── KPIs & Risks ──────────────────────────────────────────────────────────

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
            _buildSubLabel('המלצת תקציב', AppColors.primary),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                budget,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],
          if (kpis.isNotEmpty) ...[
            _buildSubLabel('KPI – מה למדוד', const Color(0xFF10B981)),
            const SizedBox(height: 6),
            _buildBullets(kpis),
            const SizedBox(height: 14),
          ],
          if (risks.isNotEmpty) ...[
            _buildSubLabel('סיכונים ואזהרות', AppColors.error),
            const SizedBox(height: 6),
            _buildBullets(risks),
          ],
        ],
      ),
    );
  }

  // ── Sub-label ─────────────────────────────────────────────────────────────

  Widget _buildSubLabel(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final sections = [
      _buildSummaryCard(),
      _buildStrengthsWeaknessesCard(),
      _buildAudienceCard(),
      _buildPositioningCard(),
      _buildChannelsCard(),
      _buildContentStrategyCard(),
      _buildWeeklyPlanCard(),
      _buildKpisAndRisksCard(),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('תוכנית השיווק החכמה'),
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: AppColors.gradient),
          ),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: PremiumResultBackground(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 980;

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 36),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _PremiumReportHero(
                          strings: _strings,
                          animation: _anim,
                          onCopyAll: _copyReport,
                          onSave: () => _soon(_strings.postResultSaveSoon),
                          onShare: () => _soon(_strings.postResultShareSoon),
                        ),
                        const SizedBox(height: 22),
                        if (isWide)
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 28,
                                  child: _ReportInsightsPanel(strings: _strings),
                                ),
                                const SizedBox(width: 18),
                                Expanded(
                                  flex: 72,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        _strings.reportResultSectionsTitle,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.textLight,
                                          letterSpacing: 0.6,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      ...sections.map(
                                        (s) => StaggeredReveal(
                                          animation: _anim,
                                          delay: 0.15,
                                          child: s,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        else ...[
                          _ReportInsightsPanel(strings: _strings),
                          const SizedBox(height: 16),
                          ...sections.map(
                            (s) => StaggeredReveal(
                              animation: _anim,
                              delay: 0.12,
                              child: s,
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        const PostGeneratorCard(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
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

// ══════════════════════════════════════════════════════════════
// Result page header
// ══════════════════════════════════════════════════════════════

class _PremiumReportHero extends StatelessWidget {
  final AppStrings strings;
  final Animation<double> animation;
  final VoidCallback onCopyAll;
  final VoidCallback onSave;
  final VoidCallback onShare;

  const _PremiumReportHero({
    required this.strings,
    required this.animation,
    required this.onCopyAll,
    required this.onSave,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return StaggeredReveal(
      animation: animation,
      delay: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(28, 30, 28, 26),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0F0F23), Color(0xFF1E1B4B), Color(0xFF312E81)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x400F0F23),
              blurRadius: 32,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AnimatedSuccessBadge(size: 48),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.reportResultSuccessTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        strings.reportResultSuccessSubtitle,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.78),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                PremiumToolbarAction(
                  icon: Icons.copy_all_rounded,
                  label: strings.reportResultCopyAll,
                  onTap: onCopyAll,
                  primary: true,
                ),
                PremiumToolbarAction(
                  icon: Icons.bookmark_add_outlined,
                  label: strings.reportResultSave,
                  onTap: onSave,
                ),
                PremiumToolbarAction(
                  icon: Icons.ios_share_rounded,
                  label: strings.reportResultShare,
                  onTap: onShare,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportInsightsPanel extends StatelessWidget {
  final AppStrings strings;

  const _ReportInsightsPanel({required this.strings});

  @override
  Widget build(BuildContext context) {
    final insights = [
      strings.reportResultInsight1,
      strings.reportResultInsight2,
      strings.reportResultInsight3,
    ];

    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppColors.gradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  strings.reportResultInsightsTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...insights.asMap().entries.map((entry) {
            final i = entry.key + 1;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: AppColors.gradient,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$i',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMedium,
                        height: 1.55,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Priority badge
// ══════════════════════════════════════════════════════════════

class _PriorityBadge extends StatelessWidget {
  final String priority;

  const _PriorityBadge({required this.priority});

  Color get _color {
    switch (priority.toLowerCase()) {
      case 'high':
      case 'גבוה':
        return const Color(0xFFEF4444);
      case 'medium':
      case 'בינוני':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF10B981);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withValues(alpha: 0.3)),
      ),
      child: Text(
        priority.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: _color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
