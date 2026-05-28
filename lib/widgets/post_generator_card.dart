import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_colors.dart';
import '../localization/app_language.dart';
import '../localization/strings.dart';
import '../models/post_generator_models.dart';
import 'hashtag_analysis_panel.dart';
import 'premium_result_ui.dart';

/// Optional metadata shown in the result sidebar.
class PostResultMetadata {
  final String platform;
  final String goal;
  final String tone;
  final String business;
  final String audience;
  final String offer;
  final String theme;
  final String location;
  final DateTime? generatedAt;

  const PostResultMetadata({
    required this.platform,
    required this.goal,
    required this.tone,
    required this.business,
    required this.audience,
    required this.offer,
    required this.theme,
    this.location = '',
    this.generatedAt,
  });
}

/// Premium SaaS result view for generated posts.
class PostGeneratorCard extends StatefulWidget {
  final PostGeneratorResponse post;
  final AppStrings? strings;
  final PostResultMetadata? metadata;
  final VoidCallback? onEdit;
  final VoidCallback? onGenerateAnother;
  final HashtagGroups? hashtags;
  final String? displayPost;
  final String? businessCategory;
  final String? postObjective;
  final VoidCallback? onRegenerateHashtags;
  final bool isRegeneratingHashtags;
  final String? hashtagError;

  const PostGeneratorCard({
    super.key,
    required this.post,
    this.strings,
    this.metadata,
    this.onEdit,
    this.onGenerateAnother,
    this.hashtags,
    this.displayPost,
    this.businessCategory,
    this.postObjective,
    this.onRegenerateHashtags,
    this.isRegeneratingHashtags = false,
    this.hashtagError,
  });

  @override
  State<PostGeneratorCard> createState() => _PostGeneratorCardState();
}

class _PostGeneratorCardState extends State<PostGeneratorCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;

  AppStrings get _s => widget.strings ?? AppStrings(AppLanguage.he);

  HashtagGroups get _hashtags => widget.hashtags ?? widget.post.hashtags;

  String get _displayPost =>
      widget.displayPost?.trim().isNotEmpty == true
          ? widget.displayPost!
          : widget.post.displayPost;

  String get _businessCategory =>
      widget.businessCategory ?? widget.post.businessCategory;

  String get _postObjective =>
      widget.postObjective ?? widget.post.postObjective;

  String get _allText {
    final tags = _hashtags.copyText;
    final buffer = StringBuffer()
      ..writeln(_displayPost)
      ..writeln()
      ..writeln('${_s.postResultHookLabel} ${widget.post.hook}')
      ..writeln()
      ..writeln('${_s.postResultCtaLabel} ${widget.post.cta}');
    if (tags.isNotEmpty) {
      buffer
        ..writeln()
        ..writeln(_s.hashtagPanelTitle)
        ..write(tags);
    }
    return buffer.toString();
  }

  @override
  void initState() {
    super.initState();
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

  void _copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(_s.postResultCopied, style: const TextStyle(fontSize: 13)),
          ],
        ),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _soon(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wordCount = countWords(_displayPost);
    final generatedAt = widget.metadata?.generatedAt ?? DateTime.now();
    final isHebrew = _s.lang == AppLanguage.he;

    return StaggeredReveal(
      animation: _anim,
      delay: 0,
      child: Container(
        margin: const EdgeInsets.only(top: 28),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A5B6EFF),
              blurRadius: 48,
              offset: Offset(0, 16),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _PremiumHero(
              strings: _s,
              animation: _anim,
              onCopyAll: () => _copy(_allText),
              onSave: () => _soon(_s.postResultSaveSoon),
              onShare: () => _soon(_s.postResultShareSoon),
              onEdit: widget.onEdit ?? () => _soon(_s.postResultEditSoon),
              onPublish: () => _soon(_s.postResultPublishSoon),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 980;
                final metadata = _MetadataSidebar(
                  strings: _s,
                  metadata: widget.metadata,
                  wordCount: wordCount,
                  charCount: _displayPost.length,
                  generatedAt: generatedAt,
                  isHebrew: isHebrew,
                );
                final tips = _TipsSidebar(strings: _s);
                final main = _MainContentColumn(
                  strings: _s,
                  post: widget.post,
                  displayPost: _displayPost,
                  hashtags: _hashtags,
                  businessCategory: _businessCategory,
                  postObjective: _postObjective,
                  animation: _anim,
                  onCopy: _copy,
                  onRegenerateHashtags: widget.onRegenerateHashtags,
                  isRegeneratingHashtags: widget.isRegeneratingHashtags,
                  hashtagError: widget.hashtagError,
                );

                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                  child: isWide
                      ? IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 27, child: metadata),
                              const SizedBox(width: 18),
                              Expanded(flex: 46, child: main),
                              const SizedBox(width: 18),
                              Expanded(flex: 27, child: tips),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            metadata,
                            const SizedBox(height: 16),
                            main,
                            const SizedBox(height: 16),
                            tips,
                          ],
                        ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: StaggeredReveal(
                animation: _anim,
                delay: 0.45,
                child: Center(
                  child: PremiumGradientButton(
                    label: _s.postResultGenerateAnother,
                    icon: Icons.auto_fix_high_rounded,
                    onTap: widget.onGenerateAnother ?? () {},
                    outlined: widget.onGenerateAnother == null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumHero extends StatelessWidget {
  final AppStrings strings;
  final Animation<double> animation;
  final VoidCallback onCopyAll;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final VoidCallback onEdit;
  final VoidCallback onPublish;

  const _PremiumHero({
    required this.strings,
    required this.animation,
    required this.onCopyAll,
    required this.onSave,
    required this.onShare,
    required this.onEdit,
    required this.onPublish,
  });

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 680;

    return Container(
      padding: EdgeInsets.fromLTRB(28, 32, 28, compact ? 22 : 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF4338CA),
            Color(0xFF5B6EFF),
            Color(0xFF9B5BFF),
            Color(0xFF7C3AED),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(top: -40, right: -10, child: _orb(140, 0.1)),
          Positioned(bottom: -50, left: 30, child: _orb(100, 0.08)),
          StaggeredReveal(
            animation: animation,
            delay: 0.02,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AnimatedSuccessBadge(),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            strings.postResultSuccessTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              height: 1.15,
                              letterSpacing: -0.6,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            strings.postResultSuccessSubtitle,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.88),
                              fontSize: 15,
                              height: 1.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    PremiumToolbarAction(
                      icon: Icons.copy_all_rounded,
                      label: strings.postResultCopyAll,
                      onTap: onCopyAll,
                      primary: true,
                    ),
                    PremiumToolbarAction(
                      icon: Icons.bookmark_add_outlined,
                      label: strings.postResultSave,
                      onTap: onSave,
                    ),
                    PremiumToolbarAction(
                      icon: Icons.ios_share_rounded,
                      label: strings.postResultShare,
                      onTap: onShare,
                    ),
                    PremiumToolbarAction(
                      icon: Icons.edit_outlined,
                      label: strings.postResultEdit,
                      onTap: onEdit,
                    ),
                    PremiumToolbarAction(
                      icon: Icons.rocket_launch_outlined,
                      label: strings.postResultPublish,
                      onTap: onPublish,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _orb(double size, double alpha) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: alpha),
      ),
    );
  }
}

class _MetadataSidebar extends StatelessWidget {
  final AppStrings strings;
  final PostResultMetadata? metadata;
  final int wordCount;
  final int charCount;
  final DateTime generatedAt;
  final bool isHebrew;

  const _MetadataSidebar({
    required this.strings,
    required this.metadata,
    required this.wordCount,
    required this.charCount,
    required this.generatedAt,
    required this.isHebrew,
  });

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _panelTitle(Icons.insights_rounded, strings.postResultMetadataTitle),
          const SizedBox(height: 18),
          if (metadata != null) ...[
            _statTile(
              Icons.share_outlined,
              strings.postGenPlatformLabel,
              metadata!.platform,
              AppColors.primary,
            ),
            const SizedBox(height: 10),
            _statTile(
              Icons.record_voice_over_outlined,
              strings.postGenToneLabel,
              metadata!.tone,
              const Color(0xFF8B5CF6),
            ),
            const SizedBox(height: 10),
            _statTile(
              Icons.flag_outlined,
              strings.postGenGoalLabel,
              metadata!.goal,
              const Color(0xFF06B6D4),
            ),
            if (metadata!.theme.trim().isNotEmpty) ...[
              const SizedBox(height: 14),
              _detailBlock(strings.postGenThemeLabel, metadata!.theme),
            ],
            if (metadata!.location.trim().isNotEmpty)
              _detailBlock(strings.postGenLocationLabel, metadata!.location),
            if (metadata!.business.trim().isNotEmpty)
              _detailBlock(strings.postGenBusinessLabel, metadata!.business),
          ],
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _metricPill(
                  Icons.format_size_rounded,
                  '$wordCount',
                  strings.postResultWordCount,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _metricPill(
                  Icons.text_fields_rounded,
                  '$charCount',
                  strings.postResultCharCount,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                const Icon(Icons.schedule_rounded, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${strings.postResultGeneratedAt} ${formatGeneratedTime(generatedAt, isHebrew: isHebrew)}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _panelTitle(IconData icon, String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: AppColors.gradient,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _statTile(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: color.withValues(alpha: 0.85),
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailBlock(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textMedium,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricPill(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: AppColors.textLight),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _TipsSidebar extends StatelessWidget {
  final AppStrings strings;

  const _TipsSidebar({required this.strings});

  @override
  Widget build(BuildContext context) {
    final tips = [
      (Icons.flash_on_rounded, strings.postResultTipHook, const Color(0xFFF59E0B)),
      (Icons.touch_app_rounded, strings.postResultTipCta, const Color(0xFF10B981)),
      (Icons.tag_rounded, strings.postResultTipHashtags, AppColors.primary),
      (Icons.schedule_rounded, strings.postResultTipTiming, const Color(0xFF06B6D4)),
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
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.lightbulb_rounded,
                    size: 16, color: Color(0xFFF59E0B)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  strings.postResultTipsTitle,
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
          ...tips.map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: t.$3.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: t.$3.withValues(alpha: 0.15)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(t.$1, size: 18, color: t.$3),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        t.$2,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MainContentColumn extends StatelessWidget {
  final AppStrings strings;
  final PostGeneratorResponse post;
  final String displayPost;
  final HashtagGroups hashtags;
  final String businessCategory;
  final String postObjective;
  final Animation<double> animation;
  final ValueChanged<String> onCopy;
  final VoidCallback? onRegenerateHashtags;
  final bool isRegeneratingHashtags;
  final String? hashtagError;

  const _MainContentColumn({
    required this.strings,
    required this.post,
    required this.displayPost,
    required this.hashtags,
    required this.businessCategory,
    required this.postObjective,
    required this.animation,
    required this.onCopy,
    this.onRegenerateHashtags,
    this.isRegeneratingHashtags = false,
    this.hashtagError,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StaggeredReveal(
          animation: animation,
          delay: 0.12,
          child: _HeroPostCard(
            label: strings.postResultTitle,
            text: displayPost,
            copyLabel: strings.postResultCopy,
            onCopy: () => onCopy(displayPost),
          ),
        ),
        const SizedBox(height: 16),
        StaggeredReveal(
          animation: animation,
          delay: 0.22,
          child: _HookCtaCard(
            icon: Icons.bolt_rounded,
            label: strings.postResultHookLabel,
            text: post.hook,
            gradient: const [Color(0xFFFBBF24), Color(0xFFF59E0B)],
            surface: const Color(0xFFFFFBEB),
            copyLabel: strings.postResultCopy,
            onCopy: () => onCopy(post.hook),
          ),
        ),
        const SizedBox(height: 14),
        StaggeredReveal(
          animation: animation,
          delay: 0.3,
          child: _HookCtaCard(
            icon: Icons.ads_click_rounded,
            label: strings.postResultCtaLabel,
            text: post.cta,
            gradient: const [Color(0xFF34D399), Color(0xFF10B981)],
            surface: const Color(0xFFECFDF5),
            copyLabel: strings.postResultCopy,
            onCopy: () => onCopy(post.cta),
          ),
        ),
        const SizedBox(height: 18),
        HashtagAnalysisPanel(
          strings: strings,
          hashtags: hashtags,
          businessCategory: businessCategory,
          postObjective: postObjective,
          isLoading: isRegeneratingHashtags,
          errorMessage: hashtagError,
          onRegenerate: onRegenerateHashtags ?? () {},
          animation: animation,
        ),
      ],
    );
  }
}

class _HeroPostCard extends StatelessWidget {
  final String label;
  final String text;
  final String copyLabel;
  final VoidCallback onCopy;

  const _HeroPostCard({
    required this.label,
    required this.text,
    required this.copyLabel,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: Color(0x145B6EFF), blurRadius: 32, offset: Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(22, 20, 18, 18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.06),
                  AppColors.primaryDark.withValues(alpha: 0.03),
                ],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: AppColors.gradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x405B6EFF),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.article_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                _CopyChip(label: copyLabel, onTap: onCopy),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(26, 28, 26, 32),
            child: ReadableContentText(
              text: text,
              fontSize: 19,
              fontWeight: FontWeight.w500,
              height: 1.85,
            ),
          ),
        ],
      ),
    );
  }
}

class _HookCtaCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String text;
  final List<Color> gradient;
  final Color surface;
  final String copyLabel;
  final VoidCallback onCopy;

  const _HookCtaCard({
    required this.icon,
    required this.label,
    required this.text,
    required this.gradient,
    required this.surface,
    required this.copyLabel,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    if (text.trim().isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: gradient.last.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
            color: gradient.last.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 14, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: gradient),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: gradient.last,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                _CopyChip(label: copyLabel, onTap: onCopy, color: gradient.last),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            child: SelectableText(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CopyChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _CopyChip({required this.label, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;

    return Material(
      color: c.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.copy_rounded, size: 14, color: c),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: c,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
