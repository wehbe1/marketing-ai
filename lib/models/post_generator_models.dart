// lib/models/post_generator_models.dart

class PostGeneratorRequest {
  final String platform;
  final String goal;
  final String tone;
  final String business;
  final String audience;
  final String offer;
  final String theme;

  PostGeneratorRequest({
    required this.platform,
    required this.goal,
    required this.tone,
    required this.business,
    required this.audience,
    required this.offer,
    required this.theme,
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
    };
  }
}

class PostGeneratorResponse {
  final String post; // טקסט הפוסט
  final String hook; // ה-Hook
  final String cta; // ה-CTA

  PostGeneratorResponse({
    required this.post,
    required this.hook,
    required this.cta,
  });

  factory PostGeneratorResponse.fromJson(Map<String, dynamic> json) {
    return PostGeneratorResponse(
      post: json['post'] ?? '',
      hook: json['hook'] ?? '',
      cta: json['cta'] ?? '',
    );
  }
}
