import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../localization/app_language.dart';
import '../providers/language_provider.dart';
import '../router.dart';
import '../widgets/primary_button.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final s = lang.s;
    final isRtl = lang.isRtl;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          // ── Nav bar ──────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            floating: false,
            backgroundColor: AppColors.surface,
            elevation: 0,
            scrolledUnderElevation: 1,
            automaticallyImplyLeading: false,
            title: _NavBar(s: s, isRtl: isRtl, lang: lang),
            titleSpacing: 0,
          ),

          // ── Hero ──────────────────────────────────────────────────────
          SliverToBoxAdapter(child: _HeroSection(s: s)),

          // ── Features ─────────────────────────────────────────────────
          SliverToBoxAdapter(child: _FeaturesSection(s: s)),

          // ── How it works ─────────────────────────────────────────────
          SliverToBoxAdapter(child: _HowItWorksSection(s: s)),

          // ── CTA ───────────────────────────────────────────────────────
          SliverToBoxAdapter(child: _CtaBanner(s: s)),

          // ── Footer ────────────────────────────────────────────────────
          SliverToBoxAdapter(child: _Footer()),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Nav bar
// ═══════════════════════════════════════════════════════════

class _NavBar extends StatelessWidget {
  final dynamic s;
  final bool isRtl;
  final LanguageProvider lang;

  const _NavBar({required this.s, required this.isRtl, required this.lang});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          // Logo
          _Logo(),
          const Spacer(),
          // Language toggle
          _LangToggle(lang: lang),
          const SizedBox(width: 12),
          // Login
          TextButton(
            onPressed: () => context.go(AppRoutes.login),
            child: Text(s.loginButton),
          ),
          const SizedBox(width: 8),
          // Get started
          PrimaryButton(
            label: s.landingCtaPrimary,
            onPressed: () => context.go(AppRoutes.register),
          ),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            gradient: AppColors.gradient,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 10),
        const Text(
          'MarketingAI',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}

class _LangToggle extends StatelessWidget {
  final LanguageProvider lang;
  const _LangToggle({required this.lang});

  @override
  Widget build(BuildContext context) {
    final isHe = lang.language == AppLanguage.he;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LangBtn(
            label: 'EN',
            active: !isHe,
            onTap: () => lang.setLanguage(AppLanguage.en),
          ),
          _LangBtn(
            label: 'HE',
            active: isHe,
            onTap: () => lang.setLanguage(AppLanguage.he),
          ),
        ],
      ),
    );
  }
}

class _LangBtn extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _LangBtn({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          gradient: active ? AppColors.gradient : null,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: active ? Colors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Hero
// ═══════════════════════════════════════════════════════════

class _HeroSection extends StatelessWidget {
  final dynamic s;
  const _HeroSection({required this.s});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width > 900;

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.heroGradient),
      child: Stack(
        children: [
          // Background grid decoration
          Positioned.fill(
            child: CustomPaint(painter: _GridPainter()),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 80 : 24,
              vertical: isWide ? 80 : 56,
            ),
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 3, child: _HeroText(s: s)),
                      const SizedBox(width: 60),
                      Expanded(flex: 2, child: _HeroVisual()),
                    ],
                  )
                : Column(
                    children: [
                      _HeroText(s: s),
                      const SizedBox(height: 48),
                      _HeroVisual(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  final dynamic s;
  const _HeroText({required this.s});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.auto_awesome, color: AppColors.primary, size: 14),
              SizedBox(width: 6),
              Text(
                'GPT-5 & Claude Sonnet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          s.landingHeroTitle,
          style: const TextStyle(
            fontSize: 46,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            height: 1.15,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          s.landingHeroSubtitle,
          style: TextStyle(
            fontSize: 17,
            color: AppColors.textOnDarkMuted,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 36),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            PrimaryButton(
              label: s.landingCtaPrimary,
              icon: Icons.arrow_forward,
              onPressed: () => context.go(AppRoutes.register),
            ),
            OutlinedButton(
              onPressed: () => context.go(AppRoutes.login),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white54, width: 1.5),
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 28,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(s.landingCtaSecondary),
            ),
          ],
        ),
        const SizedBox(height: 48),
        _HeroStats(),
      ],
    );
  }
}

class _HeroStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 32,
      runSpacing: 16,
      children: const [
        _StatChip(value: 'GPT-5 + Claude', label: 'AI Models'),
        _StatChip(value: 'HE / EN', label: 'Languages + RTL'),
        _StatChip(value: '∞', label: 'Reports'),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  const _StatChip({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textOnDarkMuted,
          ),
        ),
      ],
    );
  }
}

class _HeroVisual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // A stylised mock-up of the marketing report card
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          _MockCardRow(
            color: AppColors.primary,
            icon: Icons.insights,
            title: 'Marketing Plan',
          ),
          const SizedBox(height: 12),
          _MockCardRow(
            color: const Color(0xFF10B981),
            icon: Icons.edit_note,
            title: 'Post Generator',
          ),
          const SizedBox(height: 12),
          _MockCardRow(
            color: AppColors.primaryDark,
            icon: Icons.history,
            title: 'Reports',
          ),
          const SizedBox(height: 16),
          // Mock progress bars
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: const [
                _MockBar(label: 'Instagram', progress: 0.82),
                SizedBox(height: 8),
                _MockBar(label: 'WhatsApp', progress: 0.65),
                SizedBox(height: 8),
                _MockBar(label: 'Facebook', progress: 0.48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MockCardRow extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  const _MockCardRow({
    required this.color,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

class _MockBar extends StatelessWidget {
  final String label;
  final double progress;
  const _MockBar({required this.label, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              minHeight: 6,
            ),
          ),
        ),
      ],
    );
  }
}

// Custom grid background painter
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1;
    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) => false;
}

// ═══════════════════════════════════════════════════════════
// Features
// ═══════════════════════════════════════════════════════════

class _FeaturesSection extends StatelessWidget {
  final dynamic s;
  const _FeaturesSection({required this.s});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width > 700;

    return Container(
      color: AppColors.background,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24,
        vertical: 72,
      ),
      child: Column(
        children: [
          _SectionLabel(text: 'Features'),
          const SizedBox(height: 12),
          const Text(
            'Everything you need to market smarter',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 48),
          isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _FeatureCard(
                        icon: Icons.insights_rounded,
                        color: AppColors.primary,
                        title: s.landingFeat1Title,
                        desc: s.landingFeat1Desc,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _FeatureCard(
                        icon: Icons.edit_note_rounded,
                        color: const Color(0xFF10B981),
                        title: s.landingFeat2Title,
                        desc: s.landingFeat2Desc,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _FeatureCard(
                        icon: Icons.history_rounded,
                        color: AppColors.primaryDark,
                        title: s.landingFeat3Title,
                        desc: s.landingFeat3Desc,
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _FeatureCard(
                      icon: Icons.insights_rounded,
                      color: AppColors.primary,
                      title: s.landingFeat1Title,
                      desc: s.landingFeat1Desc,
                    ),
                    const SizedBox(height: 16),
                    _FeatureCard(
                      icon: Icons.edit_note_rounded,
                      color: const Color(0xFF10B981),
                      title: s.landingFeat2Title,
                      desc: s.landingFeat2Desc,
                    ),
                    const SizedBox(height: 16),
                    _FeatureCard(
                      icon: Icons.history_rounded,
                      color: AppColors.primaryDark,
                      title: s.landingFeat3Title,
                      desc: s.landingFeat3Desc,
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String desc;
  const _FeatureCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textMedium,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// How it works
// ═══════════════════════════════════════════════════════════

class _HowItWorksSection extends StatelessWidget {
  final dynamic s;
  const _HowItWorksSection({required this.s});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width > 700;

    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24,
        vertical: 72,
      ),
      child: Column(
        children: [
          _SectionLabel(text: 'How it works'),
          const SizedBox(height: 12),
          Text(
            s.landingStepTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 48),
          isWide
              ? Row(
                  children: [
                    Expanded(child: _StepCard(number: '1', text: s.landingStep1, icon: Icons.business_center_outlined)),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, color: AppColors.border, size: 28),
                    const SizedBox(width: 8),
                    Expanded(child: _StepCard(number: '2', text: s.landingStep2, icon: Icons.auto_awesome_outlined)),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, color: AppColors.border, size: 28),
                    const SizedBox(width: 8),
                    Expanded(child: _StepCard(number: '3', text: s.landingStep3, icon: Icons.rocket_launch_outlined)),
                  ],
                )
              : Column(
                  children: [
                    _StepCard(number: '1', text: s.landingStep1, icon: Icons.business_center_outlined),
                    const SizedBox(height: 16),
                    _StepCard(number: '2', text: s.landingStep2, icon: Icons.auto_awesome_outlined),
                    const SizedBox(height: 16),
                    _StepCard(number: '3', text: s.landingStep3, icon: Icons.rocket_launch_outlined),
                  ],
                ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final String number;
  final String text;
  final IconData icon;
  const _StepCard({required this.number, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  gradient: AppColors.gradient,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.textDark,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  number,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// CTA banner
// ═══════════════════════════════════════════════════════════

class _CtaBanner extends StatelessWidget {
  final dynamic s;
  const _CtaBanner({required this.s});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 56),
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      child: Column(
        children: [
          Text(
            s.landingCtaSection,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 28),
          PrimaryButton(
            label: s.landingCtaPrimary,
            icon: Icons.arrow_forward,
            onPressed: () => context.go(AppRoutes.register),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Footer
// ═══════════════════════════════════════════════════════════

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '© 2026 MarketingAI  ·  Built with GPT-5 & Claude Sonnet',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared small widgets ────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
