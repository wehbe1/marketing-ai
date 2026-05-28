import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../models/post_generator_models.dart';
import '../services/hashtag_analysis_api.dart';
import '../services/post_generator_api.dart';
import '../widgets/post_generator_card.dart';
import '../widgets/premium_result_ui.dart';
import '../localization/app_language.dart';
import '../localization/strings.dart';

class PostGeneratorScreen extends StatefulWidget {
  final AppLanguage language;

  const PostGeneratorScreen({super.key, required this.language});

  @override
  State<PostGeneratorScreen> createState() => _PostGeneratorScreenState();
}

class _PostGeneratorScreenState extends State<PostGeneratorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  final _businessController = TextEditingController();
  final _audienceController = TextEditingController();
  final _offerController = TextEditingController();
  final _themeController = TextEditingController();
  final _locationController = TextEditingController();

  String _platform = "Instagram";
  String _goal = "engagement";
  String _tone = "friendly";

  bool _loading = false;
  PostGeneratorResponse? _post;
  String? _error;
  DateTime? _generatedAt;
  HashtagGroups _hashtags = const HashtagGroups();
  String _displayPost = '';
  String _businessCategory = '';
  String _postObjective = '';
  bool _hashtagsLoading = false;
  String? _hashtagError;
  late final AppStrings strings;

  @override
  void initState() {
    super.initState();
    strings = AppStrings(widget.language);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _businessController.dispose();
    _audienceController.dispose();
    _offerController.dispose();
    _themeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  String get _goalLabel {
    switch (_goal) {
      case 'sales':
        return strings.postGenGoalSales;
      case 'awareness':
        return strings.postGenGoalAwareness;
      default:
        return strings.postGenGoalEngagement;
    }
  }

  String get _toneLabel {
    switch (_tone) {
      case 'professional':
        return strings.postGenToneProfessional;
      case 'funny':
        return strings.postGenToneFunny;
      default:
        return strings.postGenToneFriendly;
    }
  }

  void _scrollToForm() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  String get _languageCode =>
      widget.language == AppLanguage.en ? 'en' : 'he';

  void _resetForAnother() {
    setState(() {
      _post = null;
      _error = null;
      _generatedAt = null;
      _hashtags = const HashtagGroups();
      _displayPost = '';
      _businessCategory = '';
      _postObjective = '';
      _hashtagError = null;
    });
    _scrollToForm();
  }

  HashtagAnalysisRequest _hashtagRequestFromCurrent() {
    return HashtagAnalysisRequest(
      post: _displayPost.isNotEmpty ? _displayPost : (_post?.post ?? ''),
      hook: _post?.hook ?? '',
      cta: _post?.cta ?? '',
      business: _businessController.text,
      audience: _audienceController.text,
      platform: _platform,
      goal: _goal,
      tone: _tone,
      theme: _themeController.text,
      offer: _offerController.text,
      location: _locationController.text,
      language: _languageCode,
    );
  }

  Future<void> _loadHashtags({bool regenerate = false}) async {
    if (_post == null) return;
    setState(() {
      _hashtagsLoading = true;
      _hashtagError = null;
    });
    try {
      final response = await HashtagAnalysisService.analyzeHashtags(
        _hashtagRequestFromCurrent(),
      );
      if (!mounted) return;
      setState(() {
        if (response.improvedPost.trim().isNotEmpty) {
          _displayPost = response.improvedPost;
        }
        _hashtags = response.hashtags;
        _businessCategory = response.businessCategory;
        _postObjective = response.postObjective;
        _hashtagError = null;
      });
    } on HashtagAnalysisException catch (e) {
      if (!mounted) return;
      final message = e.friendlyMessage(widget.language);
      setState(() => _hashtagError = message);
      if (regenerate) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _hashtagError = strings.hashtagErrorGeneric);
      if (regenerate) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(strings.hashtagErrorGeneric),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _hashtagsLoading = false);
    }
  }

  Future<void> _regenerateHashtags() => _loadHashtags(regenerate: true);

  Future<void> _generatePost() async {
    setState(() {
      _loading = true;
      _error = null;
      _post = null;
    });

    final request = PostGeneratorRequest(
      business: _businessController.text,
      audience: _audienceController.text,
      offer: _offerController.text,
      theme: _themeController.text,
      platform: _platform,
      goal: _goal,
      tone: _tone,
      location: _locationController.text,
      language: _languageCode,
    );

    try {
      final response = await PostGeneratorService.generatePost(request);
      setState(() {
        _post = response;
        _generatedAt = DateTime.now();
        _displayPost = response.displayPost;
        _hashtags = response.hashtags;
        _businessCategory = response.businessCategory;
        _postObjective = response.postObjective;
      });
      if (response.hashtags.isEmpty) {
        await _loadHashtags();
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textDirection =
        (widget.language == AppLanguage.en)
            ? TextDirection.ltr
            : TextDirection.rtl;

    return Directionality(
      textDirection: textDirection,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(strings.postGenTitle),
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: AppColors.gradient),
          ),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: PremiumResultBackground(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(18),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: Column(
                  children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // תיאור העסק
                    TextFormField(
                      controller: _businessController,
                      textAlign:
                          textDirection == TextDirection.rtl
                              ? TextAlign.right
                              : TextAlign.left,
                      decoration: InputDecoration(
                        labelText: strings.postGenBusinessLabel,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // קהל יעד
                    TextFormField(
                      controller: _audienceController,
                      textAlign:
                          textDirection == TextDirection.rtl
                              ? TextAlign.right
                              : TextAlign.left,
                      decoration: InputDecoration(
                        labelText: strings.postGenAudienceLabel,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // הצעה שיווקית
                    TextFormField(
                      controller: _offerController,
                      textAlign:
                          textDirection == TextDirection.rtl
                              ? TextAlign.right
                              : TextAlign.left,
                      decoration: InputDecoration(
                        labelText: strings.postGenOfferLabel,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // נושא הפוסט
                    TextFormField(
                      controller: _themeController,
                      textAlign:
                          textDirection == TextDirection.rtl
                              ? TextAlign.right
                              : TextAlign.left,
                      decoration: InputDecoration(
                        labelText: strings.postGenThemeLabel,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _locationController,
                      textAlign:
                          textDirection == TextDirection.rtl
                              ? TextAlign.right
                              : TextAlign.left,
                      decoration: InputDecoration(
                        labelText: strings.postGenLocationLabel,
                        hintText: strings.postGenLocationHint,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: _platform,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: strings.postGenPlatformLabel,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'Instagram',
                          child: Text(strings.platformInstagram),
                        ),
                        DropdownMenuItem(
                          value: 'Facebook',
                          child: Text(strings.platformFacebook),
                        ),
                        DropdownMenuItem(
                          value: 'TikTok',
                          child: Text(strings.platformTikTok),
                        ),
                      ],
                      onChanged: (v) => setState(() => _platform = v!),
                    ),
                    const SizedBox(height: 16),

                    // מטרה
                    DropdownButtonFormField<String>(
                      value: _goal,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: strings.postGenGoalLabel,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: "engagement",
                          child: Text(strings.postGenGoalEngagement),
                        ),
                        DropdownMenuItem(
                          value: "sales",
                          child: Text(strings.postGenGoalSales),
                        ),
                        DropdownMenuItem(
                          value: "awareness",
                          child: Text(strings.postGenGoalAwareness),
                        ),
                      ],
                      onChanged: (v) => setState(() => _goal = v!),
                    ),
                    const SizedBox(height: 16),

                    // טון
                    DropdownButtonFormField<String>(
                      value: _tone,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: strings.postGenToneLabel,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: "friendly",
                          child: Text(strings.postGenToneFriendly),
                        ),
                        DropdownMenuItem(
                          value: "professional",
                          child: Text(strings.postGenToneProfessional),
                        ),
                        DropdownMenuItem(
                          value: "funny",
                          child: Text(strings.postGenToneFunny),
                        ),
                      ],
                      onChanged: (v) => setState(() => _tone = v!),
                    ),
                    const SizedBox(height: 20),

                    // כפתור יצירת פוסט
                    ElevatedButton(
                      onPressed: _loading ? null : _generatePost,
                      child:
                          _loading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : Text(strings.postGenButton),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              if (_loading) _PostLoadingCard(strings: strings),

              // Error state
              if (!_loading && _error != null)
                _PostErrorCard(message: _error!, strings: strings),

              // Result
              if (!_loading && _post != null)
                PostGeneratorCard(
                  post: _post!,
                  strings: strings,
                  displayPost: _displayPost,
                  hashtags: _hashtags,
                  businessCategory: _businessCategory,
                  postObjective: _postObjective,
                  metadata: PostResultMetadata(
                    platform: _platform,
                    goal: _goalLabel,
                    tone: _toneLabel,
                    business: _businessController.text,
                    audience: _audienceController.text,
                    offer: _offerController.text,
                    theme: _themeController.text,
                    location: _locationController.text,
                    generatedAt: _generatedAt,
                  ),
                  onEdit: _scrollToForm,
                  onGenerateAnother: _resetForAnother,
                  onRegenerateHashtags: _regenerateHashtags,
                  isRegeneratingHashtags: _hashtagsLoading,
                  hashtagError: _hashtagError,
                ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Loading card
// ══════════════════════════════════════════════════════════════

class _PostLoadingCard extends StatelessWidget {
  final AppStrings strings;
  const _PostLoadingCard({required this.strings});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 24, offset: Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              gradient: AppColors.gradient,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(3),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            strings.postResultLoadingTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            strings.postResultLoadingSubtitle,
            style: const TextStyle(fontSize: 14, color: AppColors.textMedium),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Error card
// ══════════════════════════════════════════════════════════════

class _PostErrorCard extends StatelessWidget {
  final String message;
  final AppStrings strings;
  const _PostErrorCard({required this.message, required this.strings});

  // Extract a human-friendly message
  String get _friendly {
    if (message.contains('Failed to fetch') || message.contains('SocketException')) {
      return 'Could not reach the server. Please check your internet connection and try again.';
    }
    if (message.contains('500') || message.contains('503')) {
      return 'The server encountered an error. Please try again in a moment.';
    }
    if (message.contains('timeout') || message.contains('TimeoutException')) {
      return 'The request timed out. The AI might be busy — please try again.';
    }
    return 'Something went wrong. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.postResultErrorTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.error,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _friendly,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMedium,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
