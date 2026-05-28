import 'package:flutter/material.dart';

import '../models/post_generator_models.dart';
import '../services/post_generator_api.dart';
import '../widgets/post_generator_card.dart';
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

  final _businessController = TextEditingController();
  final _audienceController = TextEditingController();
  final _offerController = TextEditingController();
  final _themeController = TextEditingController();

  String _platform = "Instagram";
  String _goal = "engagement";
  String _tone = "friendly";

  bool _loading = false;
  PostGeneratorResponse? _post;
  late final AppStrings strings;

  @override
  void initState() {
    super.initState();
    strings = AppStrings(widget.language);
  }

  Future<void> _generatePost() async {
    setState(() => _loading = true);

    final request = PostGeneratorRequest(
      business: _businessController.text,
      audience: _audienceController.text,
      offer: _offerController.text,
      theme: _themeController.text,
      platform: _platform,
      goal: _goal,
      tone: _tone,
    );

    try {
      final response = await PostGeneratorService.generatePost(request);
      setState(() => _post = response);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("שגיאה: $e")));
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
        appBar: AppBar(title: Text(strings.postGenTitle)),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
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
                    const SizedBox(height: 16),

                    // פלטפורמה
                    DropdownButtonFormField<String>(
                      value: _platform,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: strings.postGenPlatformLabel,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "Instagram",
                          child: Text("Instagram"),
                        ),
                        DropdownMenuItem(
                          value: "Facebook",
                          child: Text("Facebook"),
                        ),
                        DropdownMenuItem(
                          value: "TikTok",
                          child: Text("TikTok"),
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

              if (_post != null)
                PostGeneratorCard(
                  post: _post!,
                  // אם עדכנת את PostGeneratorCard כך שיקבל גם strings:
                  // strings: strings,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
