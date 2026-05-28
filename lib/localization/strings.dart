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

  String get analysisPostHookLabel =>
      _tr('משפט פתיחה:', 'Opening hook:', 'جملة الافتتاح:');

  String get analysisPostCtaLabel =>
      _tr('קריאה לפעולה:', 'Call to action:', 'نداء للإجراء:');

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
    'מדדי הצלחה — מה למדוד',
    'Success metrics — what to measure',
    'مؤشرات النجاح — ما الذي نقيسه',
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
    'הגדלת סל קנייה',
    'Upsell & higher order value',
    'زيادة قيمة سلة الشراء',
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

  String get postGenLocationLabel =>
      _tr('מיקום / אזור', 'Location / area', 'الموقع / المنطقة');

  String get postGenLocationHint => _tr(
    'לדוגמה: חיפה, תל אביב, השרון',
    'e.g. Haifa, Tel Aviv, Sharon area',
    'مثال: حيفا، تل أبيب',
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
      _tr('הפוסט שנוצר', 'Generated post', 'المنشور المُنشأ');

  String get postResultHookLabel =>
      _tr('משפט פתיחה', 'Opening hook', 'جملة الافتتاح');

  String get postResultCtaLabel =>
      _tr('קריאה לפעולה', 'Call to action', 'نداء للإجراء');

  String get postResultSuccessTitle =>
      _tr('הפוסט שלך מוכן!', 'Your post is ready!', 'منشورك جاهز!');

  String get postResultSuccessSubtitle => _tr(
    'תוכן מותאם אישית — מוכן להעתקה, עריכה ופרסום',
    'Tailored content — ready to copy, edit, and publish',
    'محتوى مخصص — جاهز للنسخ والتعديل والنشر',
  );

  String get postResultCopyAll =>
      _tr('העתק הכל', 'Copy all', 'نسخ الكل');

  String get postResultCopy => _tr('העתק', 'Copy', 'نسخ');

  String get postResultCopied =>
      _tr('הועתק!', 'Copied!', 'تم النسخ!');

  String get postResultSave =>
      _tr('שמור', 'Save', 'حفظ');

  String get postResultSaveSoon => _tr(
    'שמירת דוחות תהיה זמינה בקרוב',
    'Report saving will be available soon',
    'حفظ التقارير سيكون متاحاً قريباً',
  );

  String get postResultEdit =>
      _tr('ערוך', 'Edit', 'تعديل');

  String get postResultPublish =>
      _tr('פרסם', 'Publish', 'نشر');

  String get postResultPublishSoon => _tr(
    'פרסום ישיר יהיה זמין בקרוב',
    'Direct publishing will be available soon',
    'النشر المباشر سيكون متاحاً قريباً',
  );

  String get postResultMetadataTitle =>
      _tr('פרטי הפוסט', 'Post details', 'تفاصيل المنشور');

  String get postResultTipsTitle =>
      _tr('טיפים לפרסום', 'Publishing tips', 'نصائح للنشر');

  String get postResultNotesTitle =>
      _tr('הערות אסטרטגיות', 'Strategy notes', 'ملاحظات استراتيجية');

  String get postResultReadFullPost => _tr(
    'קרא את הפוסט המלא',
    'Read the full post',
    'اقرأ المنشور الكامل',
  );

  String get postResultCharCount => _tr('תווים', 'characters', 'حرف');

  String get postResultTipHook => _tr(
    'פתחו עם משפט הפתיחה בסרטון או בשורה הראשונה',
    'Open with the hook in your video or first line',
    'ابدأ بجملة الافتتاح في الفيديو أو السطر الأول',
  );

  String get postResultTipCta => _tr(
    'הוסיפו את קריאת הפעולה בסוף הפוסט או בתיאור',
    'Place the call to action at the end of the post or caption',
    'ضع نداء الإجراء في نهاية المنشور أو الوصف',
  );

  String get postResultTipHashtags => _tr(
    'בחרו האשטגים רלוונטיים מכל קטגוריה לשיפור החשיפה',
    'Pick relevant hashtags from each category to boost reach',
    'اختر هاشتags مناسبة من كل فئة لزيادة الوصول',
  );

  String get postResultTipTiming => _tr(
    'פרסם בשעות שיא של הקהל שלך',
    'Publish during your audience peak hours',
    'انشر خلال ساعات الذروة لجمهورك',
  );

  String get postResultShare =>
      _tr('שתף', 'Share', 'مشاركة');

  String get postResultShareSoon => _tr(
    'שיתוף יהיה זמין בקרוב',
    'Sharing will be available soon',
    'المشاركة ستكون متاحة قريباً',
  );

  String get postResultEditSoon => _tr(
    'עריכה מתקדמת תהיה זמינה בקרוב',
    'Advanced editing will be available soon',
    'التعديل المتقدم سيكون متاحاً قريباً',
  );

  String get postResultGenerateAnother => _tr(
    'צור פוסט נוסף',
    'Generate another post',
    'أنشئ منشوراً آخر',
  );

  String get postResultWordCount =>
      _tr('מילים', 'words', 'كلمات');

  String get postResultGeneratedAt =>
      _tr('נוצר ב', 'Generated at', 'أُنشئ في');

  String get postResultLoadingTitle => _tr(
    'יוצרים את הפוסט שלך...',
    'Crafting your post...',
    'جاري إنشاء منشورك...',
  );

  String get postResultLoadingSubtitle => _tr(
    'המערכת כותבת תוכן מותאם אישית עבורך',
    'Our AI is writing personalized content for you',
    'الذكاء الاصطناعي يكتب محتوى مخصصاً لك',
  );

  String get hashtagPanelTitle =>
      _tr('ניתוח האשטגים חכם', 'Smart hashtag analysis', 'تحليل الهاشتags الذكي');

  String get hashtagPanelSubtitle => _tr(
    'המערכת זיהתה את נושא התוכן והמליצה על האשטגים מדויקים',
    'We detected your content topic and recommended precise hashtags',
    'حددنا موضوع المحتوى واقترحنا هاشتags دقيقة',
  );

  String get hashtagSectionHebrew =>
      _tr('האשטגים בעברית', 'Hebrew hashtags', 'هاشتags بالعبرية');

  String get hashtagSectionEnglish =>
      _tr('האשטגים באנגלית', 'English hashtags', 'هاشتags بالإنجليزية');

  String get hashtagSectionTrending =>
      _tr('האשטגים טרנדיים', 'Trending hashtags', 'هاشتags رائجة');

  String get hashtagSectionLocal =>
      _tr('האשטגים מקומיים', 'Local hashtags', 'هاشتags محلية');

  String get hashtagCopyAll =>
      _tr('העתקת כל ההאשטגים', 'Copy all hashtags', 'نسخ كل الهاشتags');

  String get hashtagRegenerate =>
      _tr('יצירת האשטגים מחדש', 'Regenerate hashtags', 'إعادة إنشاء الهاشتags');

  String get hashtagDetectedCategory =>
      _tr('סוג עסק', 'Business type', 'نوع العمل');

  String get hashtagDetectedGoal =>
      _tr('מטרת הפוסט', 'Post goal', 'هدف المنشور');

  String get hashtagEmptyState => _tr(
    'לא נמצאו האשטגים. לחצו על "יצירת האשטגים מחדש".',
    'No hashtags found. Tap "Regenerate hashtags".',
    'لم يتم العثور على هاشتags. اضغط "إعادة إنشاء الهاشتags".',
  );

  String get hashtagAnalyzing => _tr(
    'מנתחים תוכן ויוצרים האשטגים מותאמים...',
    'Analyzing content and generating tailored hashtags...',
    'جاري تحليل المحتوى وإنشاء هاشتags مخصصة...',
  );

  String get hashtagErrorGeneric => _tr(
    'לא הצלחנו לנתח האשטגים כרגע. נסו שוב.',
    'Could not analyze hashtags right now. Please try again.',
    'تعذر تحليل الهاشتags حالياً. حاول مرة أخرى.',
  );

  String get postResultErrorTitle =>
      _tr('היצירה נכשלה', 'Generation failed', 'فشل الإنشاء');

  String get reportResultSuccessTitle => _tr(
    'תוכנית השיווק שלך מוכנה',
    'Your marketing plan is ready',
    'خطة التسويق جاهزة',
  );

  String get reportResultSuccessSubtitle => _tr(
    'ניתוח מעמיק — מוכן לקריאה, העתקה ושמירה',
    'Deep AI analysis — ready to read, copy, and save',
    'تحليل عميق — جاهز للقراءة والنسخ والحفظ',
  );

  String get reportResultCopyAll =>
      _tr('העתק דוח', 'Copy report', 'نسخ التقرير');

  String get reportResultSave =>
      _tr('שמור דוח', 'Save report', 'حفظ التقرير');

  String get reportResultShare =>
      _tr('שתף', 'Share', 'مشاركة');

  String get reportResultSectionsTitle =>
      _tr('תוכן הדוח', 'Report content', 'محتوى التقرير');

  String get reportResultInsightsTitle =>
      _tr('תובנות חכמות', 'Smart insights', 'رؤى ذكية');

  String get reportResultInsight1 => _tr(
    'התחל מהסיכום — הוא מסכם את כל האסטרטגיה',
    'Start with the summary — it captures the full strategy',
    'ابدأ بالملخص — يلخص الاستراتيجية كاملة',
  );

  String get reportResultInsight2 => _tr(
    'השתמש ברעיונות הפוסטים ישירות בקמפיין',
    'Use post ideas directly in your campaign',
    'استخدم أفكار المنشورات مباشرة في حملتك',
  );

  String get reportResultInsight3 => _tr(
    'עקבו אחר מדדי ההצלחה שהמערכת המליצה עליהם',
    'Track the success metrics recommended by the system',
    'تابع مؤشرات النجاح التي أوصت بها المنظومة',
  );

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

  // =====================================================================
  // Landing page
  // =====================================================================

  String get landingHeroTitle => _tr(
    'שיווק חכם מבוסס AI\nלעסקים מצליחים',
    'AI-Powered Marketing\nfor Growing Businesses',
    'تسويق ذكي بالذكاء الاصطناعي\nللأعمال الناجحة',
  );

  String get landingHeroSubtitle => _tr(
    'צרו תוכניות שיווק מקצועיות ופוסטים מנצחים תוך שניות — באמצעות GPT ו-Claude.',
    'Create professional marketing plans and winning posts in seconds — powered by GPT and Claude.',
    'أنشئ خطط تسويق احترافية ومنشورات رائعة في ثوانٍ — مدعوم بـ GPT وClaude.',
  );

  String get landingCtaPrimary => _tr('התחל בחינם', 'Get Started Free', 'ابدأ مجاناً');

  String get landingCtaSecondary => _tr('כניסה לחשבון', 'Sign In', 'تسجيل الدخول');

  String get landingFeat1Title => _tr('תוכנית שיווק חכמה', 'Smart Marketing Plans', 'خطط تسويق ذكية');
  String get landingFeat1Desc => _tr(
    'ניתוח מעמיק של העסק, הקהל והתחרות — עם תוכנית שבועית מפורטת.',
    'Deep analysis of your business, audience and competition — with a detailed weekly plan.',
    'تحليل عميق لعملك وجمهورك والمنافسة — مع خطة أسبوعية مفصلة.',
  );

  String get landingFeat2Title =>
      _tr('מחולל פוסטים חכם', 'Smart post generator', 'مولّد منشورات ذكي');
  String get landingFeat2Desc => _tr(
    'פוסטים מדויקים לאינסטגרם, פייסבוק, ווטסאפ ועוד — עם משפט פתיחה וקריאה לפעולה חזקים.',
    'Precise posts for Instagram, Facebook, WhatsApp and more — with strong hooks and calls to action.',
    'منشورات دقيقة لإنستغرام وفيسبوك وواتساب وغيرها — مع افتتاحية ونداء للإجراء.',
  );

  String get landingFeat3Title => _tr('היסטוריית דוחות', 'Reports History', 'سجل التقارير');
  String get landingFeat3Desc => _tr(
    'כל דוחותיך שמורים ומאורגנים — פתוחים מכל מקום בכל זמן.',
    'All your reports saved and organized — accessible from anywhere, anytime.',
    'جميع تقاريرك محفوظة ومنظمة — متاحة من أي مكان وفي أي وقت.',
  );

  String get landingStepTitle => _tr('איך זה עובד?', 'How does it work?', 'كيف يعمل؟');
  String get landingStep1 => _tr('תאר את העסק שלך', 'Describe your business', 'صِف عملك');
  String get landingStep2 => _tr(
    'המערכת מנתחת ויוצרת תוכנית',
    'The system analyzes and creates a plan',
    'المنظومة تحلل وتُنشئ خطة',
  );
  String get landingStep3 => _tr('הורד ויישם מיד', 'Download and implement instantly', 'احفظ ونفّذ فوراً');

  String get landingCtaSection => _tr(
    'מוכנים לצמוח?\nהתחילו ליצור תוכנית שיווק עוד היום.',
    'Ready to grow?\nStart creating your marketing plan today.',
    'هل أنتم مستعدون للنمو؟\nابدأوا في إنشاء خطة تسويقية اليوم.',
  );

  // =====================================================================
  // Auth screens
  // =====================================================================

  String get loginTitle => _tr('ברוכים השבים', 'Welcome back', 'مرحباً بعودتك');
  String get loginSubtitle => _tr('היכנסו לחשבונכם', 'Sign in to your account', 'تسجيل الدخول إلى حسابك');
  String get loginButton => _tr('כניסה', 'Sign In', 'تسجيل الدخول');
  String get loginNoAccount => _tr('אין לך חשבון?', "Don't have an account?", 'ليس لديك حساب؟');
  String get loginRegisterLink => _tr('הירשם', 'Register', 'سجّل الآن');

  String get registerTitle => _tr('צרו חשבון', 'Create an account', 'إنشاء حساب');
  String get registerSubtitle => _tr('הצטרפו ל-MarketingAI', 'Join MarketingAI today', 'انضم إلى MarketingAI اليوم');
  String get registerButton => _tr('הירשם', 'Create Account', 'إنشاء حساب');
  String get registerHaveAccount => _tr('כבר יש לך חשבון?', 'Already have an account?', 'هل لديك حساب بالفعل؟');
  String get registerLoginLink => _tr('התחברות', 'Sign In', 'تسجيل الدخول');

  String get fieldEmail => _tr('כתובת מייל', 'Email address', 'البريد الإلكتروني');
  String get fieldPassword => _tr('סיסמה', 'Password', 'كلمة المرور');
  String get fieldFullName => _tr('שם מלא (אופציונלי)', 'Full name (optional)', 'الاسم الكامل (اختياري)');

  String get errorEmailRequired => _tr('אנא הכנס כתובת מייל', 'Please enter your email', 'يرجى إدخال البريد الإلكتروني');
  String get errorEmailInvalid => _tr('כתובת מייל לא תקינה', 'Invalid email address', 'عنوان البريد الإلكتروني غير صالح');
  String get errorPasswordRequired => _tr('אנא הכנס סיסמה', 'Please enter your password', 'يرجى إدخال كلمة المرور');
  String get errorPasswordShort => _tr('הסיסמה חייבת להכיל לפחות 8 תווים', 'Password must be at least 8 characters', 'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل');
  String get errorPasswordWeak => _tr(
    'הסיסמה חייבת להכיל לפחות 8 תווים, אות אחת ומספר אחד',
    'Password must be at least 8 characters with a letter and a number',
    'يجب أن تحتوي كلمة المرور على 8 أحرف على الأقل مع حرف ورقم',
  );

  String get authOrDivider => _tr('או', 'or', 'أو');
  String get authContinueWithGoogle => _tr('המשך עם Google', 'Continue with Google', 'المتابعة باستخدام Google');
  String get authForgotPassword => _tr('שכחת סיסמה?', 'Forgot password?', 'هل نسيت كلمة المرور؟');
  String get authForgotPasswordTitle => _tr('איפוס סיסמה', 'Reset password', 'إعادة تعيين كلمة المرور');
  String get authForgotPasswordSubtitle => _tr(
    'הזינו את כתובת המייל ונשלח לכם קישור לאיפוס הסיסמה',
    'Enter your email and we will send you a reset link',
    'أدخلوا بريدكم الإلكتروني وسنرسل رابط إعادة التعيين',
  );
  String get authSendResetLink => _tr('שליחת קישור', 'Send reset link', 'إرسال رابط');
  String get authResetEmailSent => _tr(
    'נשלח מייל לאיפוס סיסמה. בדקו את תיבת הדואר.',
    'Password reset email sent. Check your inbox.',
    'تم إرسال بريد إعادة التعيين. تحققوا من صندوق الوارد.',
  );
  String get authBackToLogin => _tr('חזרה להתחברות', 'Back to sign in', 'العودة لتسجيل الدخول');

  String get authVerifyEmailTitle => _tr('אימות כתובת מייל', 'Verify your email', 'تحقق من البريد الإلكتروني');
  String get authVerifyEmailSubtitle => _tr(
    'שלחנו מייל אימות. לחצו על הקישור במייל כדי להפעיל את החשבון.',
    'We sent a verification email. Click the link in the email to activate your account.',
    'أرسلنا بريد تحقق. انقروا على الرابط في البريد لتفعيل الحساب.',
  );
  String get authResendVerification => _tr('שליחה חוזרת של מייל אימות', 'Resend verification email', 'إعادة إرسال بريد التحقق');
  String get authCheckVerification => _tr('בדקתי — המשך', 'I verified — continue', 'تحققت — متابعة');
  String get authVerificationSent => _tr('מייל אימות נשלח שוב', 'Verification email sent again', 'تم إرسال بريد التحقق مرة أخرى');
  String get authVerificationPending => _tr(
    'המייל עדיין לא אומת. בדקו את תיבת הדואר.',
    'Email is not verified yet. Check your inbox.',
    'لم يتم التحقق من البريد بعد. تحققوا من صندوق الوارد.',
  );
  String get authSignOut => _tr('יציאה', 'Sign out', 'تسجيل الخروج');
  String get authFirebaseNotConfigured => _tr(
    'Firebase לא מוגדר. הריצו flutterfire configure.',
    'Firebase is not configured. Run flutterfire configure.',
    'Firebase غير مهيأ. شغّلوا flutterfire configure.',
  );

  String get authErrorEmailInUse => _tr('כתובת המייל כבר בשימוש', 'This email is already in use', 'البريد الإلكتروني مستخدم بالفعل');
  String get authErrorInvalidCredentials => _tr('מייל או סיסמה שגויים', 'Invalid email or password', 'البريد أو كلمة المرور غير صحيحة');
  String get authErrorUserDisabled => _tr('החשבון הושבת', 'This account has been disabled', 'تم تعطيل هذا الحساب');
  String get authErrorTooManyRequests => _tr('יותר מדי ניסיונות. נסו שוב מאוחר יותר', 'Too many attempts. Try again later', 'محاولات كثيرة. حاولوا لاحقاً');
  String get authErrorNetwork => _tr('אין חיבור לאינטרנט', 'No internet connection', 'لا يوجد اتصال بالإنترنت');
  String get authErrorProviderDisabled => _tr('שיטת ההתחברות אינה זמינה', 'This sign-in method is not enabled', 'طريقة تسجيل الدخول غير مفعّلة');
  String get authErrorRecentLogin => _tr('נדרשת התחברות מחדש', 'Please sign in again to continue', 'يلزم تسجيل الدخول مجدداً');
  String get authErrorSessionExpired => _tr('פג תוקף ההתחברות. התחברו שוב', 'Session expired. Please sign in again', 'انتهت الجلسة. سجّلوا الدخول مجدداً');
  String get authErrorServiceUnavailable => _tr('השירות אינו זמין כרגע', 'Service unavailable. Try again later', 'الخدمة غير متاحة حالياً');
  String get authErrorGoogleCanceled => _tr('ההתחברות עם Google בוטלה', 'Google sign-in was canceled', 'تم إلغاء تسجيل الدخول عبر Google');
  String get authErrorGeneric => _tr('משהו השתבש. נסו שוב', 'Something went wrong. Please try again', 'حدث خطأ. حاولوا مرة أخرى');
  String get authErrorBackendSync => _tr(
    'ההתחברות הצליחה אך לא ניתן לסנכרן עם השרת. נסו שוב.',
    'Signed in but server sync failed. Please try again.',
    'تم تسجيل الدخول لكن فشلت المزامنة مع الخادم.',
  );
  String get authErrorEmailNotVerified => _tr(
    'יש לאמת את כתובת המייל לפני כניסה למערכת',
    'Please verify your email before accessing the app',
    'يرجى التحقق من البريد قبل الدخول',
  );

  // =====================================================================
  // Dashboard
  // =====================================================================

  String get dashboardGreeting => _tr('שלום', 'Hello', 'مرحباً');
  String get dashboardSubtitle => _tr('מה נעשה היום?', 'What shall we create today?', 'ماذا ننشئ اليوم؟');

  String get dashboardNewPlan => _tr('תוכנית שיווק חדשה', 'New Marketing Plan', 'خطة تسويق جديدة');
  String get dashboardNewPlanDesc => _tr(
    'ניתוח מלא של העסק עם המלצות ערוצים, תוכנית שבועית ו-KPI',
    'Full business analysis with channel recommendations, weekly plan and KPIs',
    'تحليل كامل للعمل مع توصيات القنوات والخطة الأسبوعية ومؤشرات الأداء',
  );

  String get dashboardNewPost => _tr('צור פוסט חכם', 'Generate Smart Post', 'إنشاء منشور ذكي');
  String get dashboardNewPostDesc => _tr(
    'פוסט מותאם לפלטפורמה, לקהל ולמטרה שלך',
    'Post tailored to your platform, audience and goal',
    'منشور مخصص لمنصتك وجمهورك وهدفك',
  );

  String get dashboardRecentReports => _tr('דוחות אחרונים', 'Recent Reports', 'التقارير الأخيرة');
  String get dashboardNoReports => _tr(
    'עדיין אין דוחות שמורים.\nצרו את הדוח הראשון שלכם!',
    'No saved reports yet.\nCreate your first report!',
    'لا توجد تقارير محفوظة بعد.\nأنشئ تقريرك الأول!',
  );

  String get dashboardLogout => _tr('יציאה', 'Log Out', 'تسجيل الخروج');
  String get dashboardSettings => _tr('הגדרות', 'Settings', 'الإعدادات');

  String get reportTypeMarketing => _tr('תוכנית שיווק', 'Marketing Plan', 'خطة تسويق');
  String get reportTypePost => _tr('פוסט', 'Post', 'منشور');
}
