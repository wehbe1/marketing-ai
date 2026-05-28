// lib/models/post_generator_models.dart

class PostGeneratorRequest {
  final String platform;
  final String goal;
  final String tone;
  final String business;
  final String audience;
  final String offer;
  final String theme;
  final String location;
  final String language;

  PostGeneratorRequest({
    required this.platform,
    required this.goal,
    required this.tone,
    required this.business,
    required this.audience,
    required this.offer,
    required this.theme,
    this.location = '',
    this.language = 'he',
  });

  Map<String, dynamic> toJson() {
    return {
      'platform': platform,
      'goal': goal,
      'tone': tone,
      'business': business,
      'audience': audience,
      'offer': offer,
      'theme': theme,
      'location': location,
      'language': language,
    };
  }
}

class HashtagGroups {
  final List<String> hebrew;
  final List<String> english;
  final List<String> trending;
  final List<String> local;

  const HashtagGroups({
    this.hebrew = const [],
    this.english = const [],
    this.trending = const [],
    this.local = const [],
  });

  factory HashtagGroups.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const HashtagGroups();
    return HashtagGroups(
      hebrew: _stringList(json['hebrew_hashtags'] ?? json['hashtags_hebrew']),
      english: _stringList(json['english_hashtags'] ?? json['hashtags_english']),
      trending: _stringList(json['trending_hashtags'] ?? json['hashtags_trending']),
      local: _stringList(json['local_hashtags'] ?? json['hashtags_local']),
    );
  }

  factory HashtagGroups.fromFlatJson(Map<String, dynamic> json) {
    return HashtagGroups(
      hebrew: _stringList(json['hebrew_hashtags'] ?? json['hashtags_hebrew']),
      english: _stringList(json['english_hashtags'] ?? json['hashtags_english']),
      trending: _stringList(json['trending_hashtags'] ?? json['hashtags_trending']),
      local: _stringList(json['local_hashtags'] ?? json['hashtags_local']),
    );
  }

  bool get isEmpty =>
      hebrew.isEmpty &&
      english.isEmpty &&
      trending.isEmpty &&
      local.isEmpty;

  List<String> get all => [...hebrew, ...english, ...trending, ...local];

  String get copyText => all.join(' ');
}

class PostGeneratorResponse {
  final String post;
  final String hook;
  final String cta;
  final String improvedPost;
  final String businessCategory;
  final String postObjective;
  final HashtagGroups hashtags;

  PostGeneratorResponse({
    required this.post,
    required this.hook,
    required this.cta,
    this.improvedPost = '',
    this.businessCategory = '',
    this.postObjective = '',
    this.hashtags = const HashtagGroups(),
  });

  String get displayPost =>
      improvedPost.trim().isNotEmpty ? improvedPost : post;

  factory PostGeneratorResponse.fromJson(Map<String, dynamic> json) {
    final nested = json['hashtags'];
    final hashtags = nested is Map<String, dynamic>
        ? HashtagGroups.fromJson(nested)
        : HashtagGroups.fromFlatJson(json);

    return PostGeneratorResponse(
      post: json['post']?.toString() ?? '',
      hook: json['hook']?.toString() ?? '',
      cta: json['cta']?.toString() ?? '',
      improvedPost: json['improved_post']?.toString() ?? '',
      businessCategory: json['business_category']?.toString() ?? '',
      postObjective: json['post_objective']?.toString() ?? '',
      hashtags: hashtags,
    );
  }
}

class HashtagAnalysisRequest {
  final String post;
  final String hook;
  final String cta;
  final String business;
  final String audience;
  final String platform;
  final String goal;
  final String tone;
  final String theme;
  final String offer;
  final String location;
  final String language;

  HashtagAnalysisRequest({
    required this.post,
    required this.business,
    required this.audience,
    required this.platform,
    required this.goal,
    required this.tone,
    required this.theme,
    this.hook = '',
    this.cta = '',
    this.offer = '',
    this.location = '',
    this.language = 'he',
  });

  Map<String, dynamic> toJson() => {
    'post': post,
    'hook': hook,
    'cta': cta,
    'business': business,
    'audience': audience,
    'platform': platform,
    'goal': goal,
    'tone': tone,
    'theme': theme,
    'offer': offer,
    'location': location,
    'language': language,
  };
}

class HashtagAnalysisResponse {
  final String improvedPost;
  final String businessCategory;
  final String postObjective;
  final HashtagGroups hashtags;

  HashtagAnalysisResponse({
    required this.improvedPost,
    required this.businessCategory,
    required this.postObjective,
    required this.hashtags,
  });

  factory HashtagAnalysisResponse.fromJson(Map<String, dynamic> json) {
    return HashtagAnalysisResponse(
      improvedPost: json['improved_post']?.toString() ?? '',
      businessCategory: json['business_category']?.toString() ?? '',
      postObjective: json['post_objective']?.toString() ?? '',
      hashtags: HashtagGroups.fromFlatJson(json),
    );
  }
}

List<String> _stringList(dynamic value) {
  if (value == null) return [];
  if (value is List) {
    return value.map((e) => e.toString().trim()).where((e) => e.isNotEmpty).toList();
  }
  return [value.toString()];
}
