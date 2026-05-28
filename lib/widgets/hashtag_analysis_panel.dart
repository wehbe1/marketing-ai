import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_colors.dart';
import '../localization/strings.dart';
import '../models/post_generator_models.dart';
import 'premium_result_ui.dart';

/// Premium hashtag analysis panel with categorized chips and actions.
class HashtagAnalysisPanel extends StatelessWidget {
  final AppStrings strings;
  final HashtagGroups hashtags;
  final String? businessCategory;
  final String? postObjective;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onRegenerate;
  final Animation<double>? animation;

  const HashtagAnalysisPanel({
    super.key,
    required this.strings,
    required this.hashtags,
    this.businessCategory,
    this.postObjective,
    this.isLoading = false,
    this.errorMessage,
    required this.onRegenerate,
    this.animation,
  });

  void _copy(BuildContext context, String text) {
    if (text.trim().isEmpty) return;
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(strings.postResultCopied),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
      ),
    );
  }

  Widget _wrap(Widget child) {
    if (animation == null) return child;
    return StaggeredReveal(animation: animation!, delay: 0.38, child: child);
  }

  @override
  Widget build(BuildContext context) {
    final sections = [
      _HashtagSectionData(
        title: strings.hashtagSectionHebrew,
        icon: Icons.translate_rounded,
        color: AppColors.primary,
        tags: hashtags.hebrew,
      ),
      _HashtagSectionData(
        title: strings.hashtagSectionEnglish,
        icon: Icons.language_rounded,
        color: const Color(0xFF3B82F6),
        tags: hashtags.english,
      ),
      _HashtagSectionData(
        title: strings.hashtagSectionTrending,
        icon: Icons.trending_up_rounded,
        color: const Color(0xFFF59E0B),
        tags: hashtags.trending,
      ),
      _HashtagSectionData(
        title: strings.hashtagSectionLocal,
        icon: Icons.location_on_outlined,
        color: const Color(0xFF10B981),
        tags: hashtags.local,
      ),
    ].where((s) => s.tags.isNotEmpty).toList();

    return _wrap(
      GlassPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    gradient: AppColors.gradient,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(Icons.tag_rounded, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.hashtagPanelTitle,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        strings.hashtagPanelSubtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textMedium,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if ((businessCategory ?? '').isNotEmpty ||
                (postObjective ?? '').isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if ((businessCategory ?? '').isNotEmpty)
                    _InsightChip(
                      icon: Icons.storefront_outlined,
                      label: strings.hashtagDetectedCategory,
                      value: businessCategory!,
                    ),
                  if ((postObjective ?? '').isNotEmpty)
                    _InsightChip(
                      icon: Icons.flag_outlined,
                      label: strings.hashtagDetectedGoal,
                      value: postObjective!,
                    ),
                ],
              ),
            ],
            const SizedBox(height: 18),
            if (errorMessage != null && !isLoading)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.errorLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.error.withValues(alpha: 0.25)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.error, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textMedium,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: Column(
                  children: [
                    const SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(strokeWidth: 3),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      strings.hashtagAnalyzing,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMedium,
                      ),
                    ),
                  ],
                ),
              )
            else if (sections.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  strings.hashtagEmptyState,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMedium,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            else
              ...sections.map(
                (section) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _HashtagSection(
                    data: section,
                    copyLabel: strings.postResultCopy,
                    onCopy: () => _copy(context, section.tags.join(' ')),
                  ),
                ),
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isLoading ? null : () => _copy(context, hashtags.copyText),
                    icon: const Icon(Icons.copy_all_rounded, size: 16),
                    label: Text(strings.hashtagCopyAll),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PremiumGradientButton(
                    label: strings.hashtagRegenerate,
                    icon: Icons.refresh_rounded,
                    onTap: isLoading ? () {} : onRegenerate,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HashtagSectionData {
  final String title;
  final IconData icon;
  final Color color;
  final List<String> tags;

  const _HashtagSectionData({
    required this.title,
    required this.icon,
    required this.color,
    required this.tags,
  });
}

class _HashtagSection extends StatelessWidget {
  final _HashtagSectionData data;
  final String copyLabel;
  final VoidCallback onCopy;

  const _HashtagSection({
    required this.data,
    required this.copyLabel,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: data.color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: data.color.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(data.icon, size: 17, color: data.color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  data.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: data.color,
                  ),
                ),
              ),
              Material(
                color: data.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: onCopy,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.copy_rounded, size: 13, color: data.color),
                        const SizedBox(width: 4),
                        Text(
                          copyLabel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: data.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: data.tags.map((tag) => _HashtagChip(tag: tag, color: data.color)).toList(),
          ),
        ],
      ),
    );
  }
}

class _HashtagChip extends StatelessWidget {
  final String tag;
  final Color color;

  const _HashtagChip({required this.tag, required this.color});

  String get _normalized => tag.startsWith('#') ? tag : '#$tag';

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        _normalized,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: color.withValues(alpha: 0.95),
        ),
      ),
    );
  }
}

class _InsightChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InsightChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textLight),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 11, color: AppColors.textLight),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
