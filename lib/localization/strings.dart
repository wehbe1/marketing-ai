// lib/localization/strings.dart
import 'app_language.dart';

class AppStrings {
  final AppLanguage lang;

  AppStrings(this.lang);

  String _tr(String he, String en, String ar) {
    switch (lang) {
      case AppLanguage.he:
        return he;
      case AppLanguage.en:
        return en;
      case AppLanguage.ar:
        return ar;
    }
  }

  // ---------- אפליקציה כללית ----------
  String get appTitle =>
      _tr('מתכנן שיווק חכם', 'Smart Marketing Planner', 'مخطط تسويق ذكي');

  String get generatePlanButton => _tr(
    'צור תוכנית שיווק חכמה',
    'Generate smart marketing plan',
    'أنشئ خطة تسويق ذكية',
  );

  String get generatePostButton => _tr(
    'צור פוסט שיווקי חכם',
    'Generate marketing post',
    'أنشئ منشور تسويقي',
  );

  // ---------- כותרות סקשנים ----------
  String get sectionBusinessTitle =>
      _tr('פרטי העסק', 'Business details', 'تفاصيل العمل');

  String get sectionAudienceTitle =>
      _tr('קהל יעד', 'Target audience', 'الجمهور المستهدف');

  String get sectionCurrentMarketingTitle =>
      _tr('שיווק קיים', 'Current marketing', 'التسويق الحالي');

  String get sectionGoalsTitle =>
      _tr('מטרות עסק', 'Business goals', 'أهداف العمل');

  String get sectionCompetitionTitle => _tr(
    'תחרות ויתרון יחסי',
    'Competition & advantages',
    'المنافسة والميزة النسبية',
  );

  String get sectionConstraintsTitle =>
      _tr('מגבלות ומשאבים', 'Constraints & resources', 'القيود والموارد');

  // ---------- כן/לא ----------
  String get yes => _tr('כן', 'Yes', 'نعم');
  String get no => _tr('לא', 'No', 'لا');

  // ---------- סקשן עסק ----------
  String get businessNameLabel => _tr('שם העסק', 'Business name', 'اسم العمل');

  String get businessIndustryLabel => _tr(
    'תחום / סוג העסק (מסעדה, סטודיו, חנות...)',
    'Industry / type of business (restaurant, studio, shop...)',
    'مجال / نوع العمل (مطعم، استوديو، متجر...)',
  );

  String get businessDescriptionLabel => _tr(
    'תיאור קצר של העסק (משפט–שניים)',
    'Short description of the business (one–two sentences)',
    'وصف قصير للعمل (جملة أو جملتان)',
  );

  String get businessOfferQuestion => _tr(
    'מה אתם מציעים ללקוח?',
    'What do you offer the client?',
    'ماذا تقدم للعميل؟',
  );

  String get businessOfferProduct => _tr('מוצר', 'Product', 'منتج');

  String get businessOfferService => _tr('שירות', 'Service', 'خدمة');

  String get businessOfferBoth => _tr('שניהם', 'Both', 'كلاهما');

  // ---------- סקשן קהל יעד ----------
  String get audienceAgeLabel => _tr(
    'גילאים (לדוגמה: 18–30)',
    'Age range (e.g. 18–30)',
    'الفئة العمرية (مثال: 18–30)',
  );

  String get audienceLocationLabel => _tr(
    'מיקום (עיר/אזור/מדינה)',
    'Location (city/region/country)',
    'الموقع (مدينة/منطقة/دولة)',
  );

  String get audienceInterestsLabel =>
      _tr('תחומי עניין של הקהל', 'Audience interests', 'اهتمامات الجمهور');

  String get audiencePainPointsLabel => _tr(
    'בעיות / כאבים עיקריים של הקהל',
    'Main problems / pain points of the audience',
    'المشاكل / نقاط الألم الرئيسية للجمهور',
  );

  String get audienceBuyingTriggersLabel => _tr(
    'מה הכי גורם להם לקנות? (מחיר, איכות, אמון...)',
    'What mainly makes them buy? (price, quality, trust...)',
    'ما الذي يدفعهم للشراء؟ (السعر، الجودة، الثقة...)',
  );

  // ---------- סקשן שיווק קיים ----------
  String get currentWhereAdvertiseLabel => _tr(
    'איפה אתה מפרסם כיום?',
    'Where do you currently advertise?',
    'أين تعلن حالياً؟',
  );

  String get currentFrequencyLabel => _tr(
    'תדירות פרסום שבועית (לדוגמה: 3 פעמים)',
    'Weekly posting frequency (e.g. 3 times)',
    'وتيرة النشر الأسبوعية (مثال: 3 مرات)',
  );

  String get currentPaidCampaignsQuestion => _tr(
    'האם נעשו קמפיינים ממומנים בעבר?',
    'Have you run paid campaigns before?',
    'هل قمت بحملات مدفوعة من قبل؟',
  );

  String get currentWebsiteQuestion => _tr(
    'האם יש אתר / דף נחיתה?',
    'Do you have a website / landing page?',
    'هل لديك موقع أو صفحة هبوط؟',
  );

  String get platformFacebook => _tr('פייסבוק', 'Facebook', 'فيسبوك');
  String get platformInstagram => _tr('אינסטגרם', 'Instagram', 'إنستغرام');
  String get platformTikTok => _tr('טיקטוק', 'TikTok', 'تيك توك');
  String get platformGoogle => _tr('גוגל', 'Google', 'جوجل');
  String get platformEmail => _tr('דוא״ל', 'Email', 'البريد الإلكتروني');
  String get platformNoMarketing =>
      _tr('לא מפרסם בכלל', 'I don\'t advertise at all', 'لا أروّج إطلاقاً');

  // ---------- סקשן מטרות ----------
  String get goalsShortTermLabel => _tr(
    'מטרות קצרות טווח (חודש–שלושה)',
    'Short-term goals (1–3 months)',
    'أهداف قصيرة المدى (شهر–ثلاثة أشهر)',
  );

  String get goalsLongTermLabel => _tr(
    'מטרות ארוכות טווח (חצי שנה–שנה)',
    'Long-term goals (6–12 months)',
    'أهداف طويلة المدى (ستة أشهر–سنة)',
  );

  String get goalsNumericGoalLabel => _tr(
    'יעד מספרי (לא חובה, לדוגמה: 30 לקוחות בחודש)',
    'Numeric goal (optional, e.g. 30 clients per month)',
    'هدف رقمي (اختياري، مثال: 30 عميلاً في الشهر)',
  );

  // ---------- סקשן תחרות ----------
  String get competitionLevelLabel => _tr(
    'רמת התחרות בתחום שלך',
    'Competition level in your field',
    'مستوى المنافسة في مجالك',
  );

  String get competitionLevelLow => _tr('נמוכה', 'Low', 'منخفضة');
  String get competitionLevelMedium => _tr('בינונית', 'Medium', 'متوسطة');
  String get competitionLevelHigh => _tr('גבוהה', 'High', 'مرتفعة');

  String get competitionCompetitorsLabel => _tr(
    'מי המתחרים העיקריים שלך?',
    'Who are your main competitors?',
    'من هم منافسوك الرئيسيون؟',
  );

  String get competitionStrengthsLabel => _tr(
    'מה היתרון המרכזי שלך לעומתם?',
    'What is your main advantage compared to them?',
    'ما هي ميزتك الأساسية مقارنة بهم؟',
  );

  String get competitionWeaknessesLabel => _tr(
    'מה החיסרון העיקרי שלך כיום?',
    'What is your main disadvantage today?',
    'ما هي أكبر نقطة ضعف لديك الأن؟',
  );

  // ---------- סקשן מגבלות ----------
  String get constraintsBudgetLabel => _tr(
    'תקציב שיווק חודשי (אם אין – רשום 0)',
    'Monthly marketing budget (if none – write 0)',
    'الميزانية التسويقية الشهرية (إن لم توجد فاكتب 0)',
  );

  String get constraintsTimePerWeekLabel => _tr(
    'כמה שעות בשבוע אפשר להשקיע בשיווק?',
    'How many hours per week can you invest in marketing?',
    'كم ساعة أسبوعياً يمكنك تخصيصها للتسويق؟',
  );

  String get constraintsResourcesLabel => _tr(
    'מגבלות משאבים (אין גרפיקאי, אין צלם, ידע מוגבל וכו\')',
    'Resource limitations (no designer, no photographer, limited knowledge, etc.)',
    'قيود الموارد (لا مصمم، لا مصوّر، معرفة محدودة، إلخ)',
  );

  // ---------- כרטיסי ניתוח ----------
  String get analysisSummaryTitle =>
      _tr('סיכום כללי', 'Overall summary', 'ملخص عام');

  String get analysisStrengthsWeaknessesTitle =>
      _tr('חוזקות וחולשות', 'Strengths & weaknesses', 'نقاط القوة والضعف');

  String get analysisStrengthsLabel =>
      _tr('חוזקות:', 'Strengths:', 'نقاط القوة:');

  String get analysisWeaknessesLabel =>
      _tr('חולשות:', 'Weaknesses:', 'نقاط الضعف:');

  String get analysisAudienceTitle =>
      _tr('ניתוח קהל יעד', 'Audience analysis', 'تحليل الجمهور المستهدف');

  String get analysisAudienceWhoLabel =>
      _tr('מי הם:', 'Who they are:', 'من هم:');

  String get analysisAudienceNeedLabel =>
      _tr('מה הם צריכים:', 'What they need:', 'ماذا يحتاجون:');

  String get analysisAudienceHowSpeakLabel =>
      _tr('איך לדבר אליהם:', 'How to speak to them:', 'كيف نخاطبهم:');

  String get analysisPositioningTitle =>
      _tr('מיתוג ומיצוב', 'Brand positioning', 'العلامة التجارية والتموضع');

  String get analysisBrandPositionLabel =>
      _tr('עמדת המותג:', 'Brand position:', 'تموضع العلامة التجارية:');

  String get analysisUniqueValueLabel => _tr(
    'הצעת ערך ייחודית:',
    'Unique value proposition:',
    'عرض القيمة الفريد:',
  );

  String get analysisKeyMessagesLabel =>
      _tr('מסרים מרכזיים:', 'Key messages:', 'الرسائل الرئيسية:');

  String get analysisChannelsTitle => _tr(
    'ערוצי שיווק מומלצים',
    'Recommended marketing channels',
    'قنوات التسويق الموصى بها',
  );

  String get analysisChannelReasonLabel => _tr('למה כדאי:', 'Why:', 'لماذا:');

  String get analysisChannelUsageLabel =>
      _tr('איך להשתמש:', 'How to use it:', 'كيفية الاستخدام:');

  String get analysisContentStrategyTitle => _tr(
    'אסטרטגיית תוכן ורעיונות לפוסטים',
    'Content strategy & post ideas',
    'استراتيجية المحتوى وأفكار المنشورات',
  );

  String get analysisToneLabel =>
      _tr('טון דיבור:', 'Tone of voice:', 'نبرة الخطاب:');

  String get analysisThemesLabel =>
      _tr('תמות תוכן:', 'Content themes:', 'محاور المحتوى:');

  String get analysisPostIdeasTitle =>
      _tr('רעיונות לפוסטים:', 'Post ideas:', 'أفكار للمنشورات:');

  String get analysisPostIdeaLabel => _tr('רעיון:', 'Idea:', 'فكرة:');

  String get analysisPostHookLabel => _tr('Hook:', 'Hook:', 'جملة الجذب:');

  String get analysisPostCtaLabel => _tr('CTA:', 'CTA:', 'نداء للإجراء:');

  String get analysisWeeklyPlanTitle =>
      _tr('תכנית שבועית', 'Weekly plan', 'خطة أسبوعية');

  String get analysisWeekPrefix => _tr('שבוע', 'Week', 'الأسبوع');

  String get analysisWeekGoalSuffix => _tr('מטרה:', 'goal:', 'الهدف:');

  String get analysisWeekActionsLabel => _tr('צעדים:', 'Actions:', 'الخطوات:');

  String get analysisKpisAndRisksTitle =>
      _tr('מדדי הצלחה וסיכונים', 'KPIs & risks', 'مؤشرات النجاح والمخاطر');

  String get analysisBudgetLabel =>
      _tr('המלצת תקציב:', 'Budget recommendation:', 'توصية بالميزانية:');

  String get analysisKpisLabel => _tr(
    'KPI – מה למדוד:',
    'KPIs – what to measure:',
    'مؤشرات الأداء – ما الذي نقيسه:',
  );

  String get analysisRisksLabel =>
      _tr('סיכונים ואזהרות:', 'Risks & warnings:', 'المخاطر والتحذيرات:');

  // ---------- מיקוד יעד לתוכנית השיווק ----------
  String get goalQuestionTitle => _tr(
    'על מה תרצה שהמערכת תתמקד?',
    'What should the plan focus on?',
    'على ماذا تريد أن تركز الخطة؟',
  );

  String get goalDropdownLabel =>
      _tr('מיקוד עיקרי', 'Main focus', 'المحور الرئيسي');

  String get goalNewCustomers =>
      _tr('הגדלת לקוחות חדשים', 'Getting new customers', 'زيادة العملاء الجدد');

  String get goalRetention => _tr(
    'שימור לקוחות קיימים',
    'Retaining existing customers',
    'الحفاظ على العملاء الحاليين',
  );

  String get goalUpsell => _tr(
    'הגדלת סל קנייה / Upsell',
    'Upsell & higher order value',
    'زيادة قيمة سلة الشراء (Upsell)',
  );

  // ---------- מחולל פוסטים (Post Generator) ----------
  String get postGenTitle =>
      _tr('מחולל פוסטים חכם', 'Smart post generator', 'مولّد منشورات ذكي');

  String get postGenBusinessLabel => _tr(
    'תיאור העסק / המותג',
    'Business / brand description',
    'وصف العمل / العلامة التجارية',
  );

  String get postGenAudienceLabel => _tr(
    'קהל יעד לפוסט',
    'Target audience for the post',
    'الجمهور المستهدف للمنشور',
  );

  String get postGenOfferLabel => _tr(
    'מה מציעים בפוסט (מוצר / שירות / מבצע)',
    'What are you offering in the post (product / service / deal)',
    'ماذا تقدّم في المنشور (منتج / خدمة / عرض)',
  );

  String get postGenThemeLabel => _tr(
    'נושא / רעיון מרכזי לפוסט',
    'Main topic / idea for the post',
    'الفكرة / الموضوع الرئيسي للمنشور',
  );

  String get postGenPlatformLabel => _tr('פלטפורמה', 'Platform', 'المنصّة');

  String get postGenGoalLabel => _tr(
    'מטרה מרכזית של הפוסט',
    'Main goal of the post',
    'الهدف الرئيسي من المنشور',
  );

  String get postGenGoalEngagement => _tr(
    'מעורבות (תגובות, לייקים, שיתופים)',
    'Engagement (comments, likes, shares)',
    'تفاعل (تعليقات، إعجابات، مشاركات)',
  );

  String get postGenGoalSales =>
      _tr('מכירות / לידים', 'Sales / leads', 'مبيعات / عملاء محتملون');

  String get postGenGoalAwareness =>
      _tr('מודעות למותג', 'Brand awareness', 'زيادة الوعي بالعلامة التجارية');

  String get postGenToneLabel =>
      _tr('טון דיבור', 'Tone of voice', 'نبرة الخطاب');

  String get postGenToneFriendly => _tr('חברי וקליל', 'Friendly', 'ودي وخفيف');

  String get postGenToneProfessional => _tr('מקצועי', 'Professional', 'مهني');

  String get postGenToneFunny => _tr('מצחיק / משועשע', 'Funny', 'مضحك');

  String get postGenButton => _tr('צור פוסט', 'Generate post', 'أنشئ منشوراً');

  // ---------- תצוגת פוסט שנוצר ----------
  String get postResultTitle =>
      _tr('פוסט שנוצר:', 'Generated post:', 'المنشور المُنشأ:');

  String get postResultHookLabel => _tr('Hook:', 'Hook:', 'جملة الجذب:');

  String get postResultCtaLabel => _tr('CTA:', 'CTA:', 'نداء للإجراء:');
  // ---------- Paywall / Locked report ----------

  String get paywallTitle => _tr(
    'רוצה לפתוח את תוכנית השיווק המלאה?',
    'Do you want to unlock the full marketing plan?',
    'هل تريد فتح خطة التسويق الكاملة؟',
  );

  String get paywallDescription => _tr(
    'כרגע אתה רואה רק חלק מהניתוח.\n'
        'בגרסה המלאה תקבל:\n'
        '• מיפוי ערוצי שיווק מלא\n'
        '• רעיונות פוסטים ו-Hooks מוכנים\n'
        '• תוכנית שבועית לפי שבוע\n'
        '• תקציב מומלץ, KPI וסיכונים עיקריים',
    'Right now you only see part of the analysis.\n'
        'In the full version you will get:\n'
        '• Full mapping of marketing channels\n'
        '• Post ideas & ready hooks\n'
        '• Weekly plan by week\n'
        '• Recommended budget, KPIs & main risks',
    'حالياً أنت ترى جزءاً فقط من التحليل.\n'
        'في النسخة الكاملة ستحصل على:\n'
        '• خريطة كاملة لقنوات التسويق\n'
        '• أفكار منشورات و-Hooks جاهزة\n'
        '• خطة أسبوعية حسب الأسابيع\n'
        '• ميزانية مقترحة، مؤشرات نجاح ومخاطر رئيسية',
  );

  String get paywallPricingTitle => _tr('תמחור:', 'Pricing:', 'التسعير:');

  String get paywallSinglePrefix =>
      _tr('• דו״ח מלא אחד:', '• One full report:', '• تقرير كامل واحد:');

  String get paywallBundlePrefix => _tr(
    '• חבילת 3 דוחות (לעתיד):',
    '• 3-report bundle (later):',
    '• حزمة 3 تقارير (لاحقاً):',
  );

  String get paywallPrimaryButton =>
      _tr('פתח דו״ח מלא', 'Unlock full report', 'افتح التقرير الكامل');

  String get paywallBundleButton =>
      _tr('חבילת 3 דוחות', '3-report bundle', 'حزمة 3 تقارير');

  String get paywallDemoNote => _tr(
    '⚠️ כרגע זה מצב הדגמה בלבד – אין תשלום אמיתי.\n'
        'בעתיד נחבר כאן סליקה ונפתח גישה לפי תשלום.',
    '⚠️ Demo mode only – no real payment yet.\n'
        'Later we will connect payments and unlock access after purchase.',
    '⚠️ هذا وضع تجريبي فقط – لا توجد دفعة حقيقية الآن.\n'
        'لاحقاً سنربط نظام دفع ونفتح الوصول بعد الشراء.',
  );

  String get paywallSnackFullOpened => _tr(
    'הדגמה בלבד: הדו״ח המלא נפתח ללא תשלום.',
    'Demo only: full report opened without payment.',
    'وضع تجريبي فقط: تم فتح التقرير الكامل بدون دفع.',
  );

  String get paywallSnackBundleOpened => _tr(
    'הדגמה בלבד: חבילת 3 דוחות – כרגע נפתח דו״ח אחד.',
    'Demo only: 3-report bundle – currently opened one report.',
    'وضع تجريبي فقط: حزمة 3 تقارير – حالياً فُتح تقرير واحد.',
  );
}
