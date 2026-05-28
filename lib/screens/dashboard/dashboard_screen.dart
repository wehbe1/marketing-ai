import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final lang = context.watch<LanguageProvider>();
    final s = lang.s;
    final user = auth.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _DashAppBar(user: user, s: s, lang: lang),
      drawer: _DashDrawer(s: s, auth: auth),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Greeting ─────────────────────────────────────────────
              _GreetingBanner(user: user, s: s),
              const SizedBox(height: 28),

              // ── Stats ─────────────────────────────────────────────────
              _StatsRow(),
              const SizedBox(height: 28),

              // ── Quick actions ─────────────────────────────────────────
              Text(
                'Quick Actions',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 14),
              _ActionCards(s: s),
              const SizedBox(height: 28),

              // ── Recent reports placeholder ────────────────────────────
              Row(
                children: [
                  Text(
                    s.dashboardRecentReports,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View all'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _RecentReportsPlaceholder(s: s),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// App Bar
// ═══════════════════════════════════════════════════════════

class _DashAppBar extends StatelessWidget implements PreferredSizeWidget {
  final dynamic user;
  final dynamic s;
  final LanguageProvider lang;

  const _DashAppBar({required this.user, required this.s, required this.lang});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      scrolledUnderElevation: 1,
      leading: Builder(
        builder: (ctx) => IconButton(
          icon: const Icon(Icons.menu_rounded, color: AppColors.textDark),
          onPressed: () => Scaffold.of(ctx).openDrawer(),
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              gradient: AppColors.gradient,
              borderRadius: BorderRadius.all(Radius.circular(7)),
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 15),
          ),
          const SizedBox(width: 8),
          const Text(
            'MarketingAI',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
      actions: [
        // Language toggle
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: TextButton(
            onPressed: lang.toggle,
            child: Text(
              lang.language.name.toUpperCase(),
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        // Avatar
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () {},
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryLight,
              child: Text(
                user?.initials ?? '?',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Drawer
// ═══════════════════════════════════════════════════════════

class _DashDrawer extends StatelessWidget {
  final dynamic s;
  final AuthProvider auth;
  const _DashDrawer({required this.s, required this.auth});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: AppColors.heroGradient,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    child: Text(
                      auth.user?.initials ?? '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          auth.user?.displayName ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          auth.user?.email ?? '',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Nav items
            _DrawerItem(
              icon: Icons.dashboard_rounded,
              label: 'Dashboard',
              active: true,
              onTap: () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Icons.insights_rounded,
              label: s.dashboardNewPlan,
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.marketing);
              },
            ),
            _DrawerItem(
              icon: Icons.edit_note_rounded,
              label: s.dashboardNewPost,
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.posts);
              },
            ),
            _DrawerItem(
              icon: Icons.history_rounded,
              label: s.dashboardRecentReports,
              onTap: () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Icons.settings_outlined,
              label: s.dashboardSettings,
              onTap: () => Navigator.pop(context),
            ),

            const Spacer(),
            const Divider(),

            // Logout
            _DrawerItem(
              icon: Icons.logout_rounded,
              label: s.dashboardLogout,
              color: AppColors.error,
              onTap: () async {
                Navigator.pop(context);
                await auth.logout();
                if (context.mounted) context.go(AppRoutes.landing);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  final Color? color;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? (active ? AppColors.primary : AppColors.textMedium);
    return ListTile(
      leading: Icon(icon, color: effectiveColor, size: 20),
      title: Text(
        label,
        style: TextStyle(
          color: effectiveColor,
          fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          fontSize: 14,
        ),
      ),
      selected: active,
      selectedTileColor: AppColors.primaryLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      onTap: onTap,
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Greeting banner
// ═══════════════════════════════════════════════════════════

class _GreetingBanner extends StatelessWidget {
  final dynamic user;
  final dynamic s;
  const _GreetingBanner({required this.user, required this.s});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: AppColors.gradient,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${s.dashboardGreeting}, ${user?.displayName ?? ''}! 👋',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  s.dashboardSubtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Stats row
// ═══════════════════════════════════════════════════════════

class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 500;
        final cards = [
          _StatCard(
            icon: Icons.description_outlined,
            label: 'Total Reports',
            value: '—',
            color: AppColors.primary,
          ),
          _StatCard(
            icon: Icons.insights_outlined,
            label: 'Marketing Plans',
            value: '—',
            color: const Color(0xFF10B981),
          ),
          _StatCard(
            icon: Icons.edit_note_outlined,
            label: 'Posts Created',
            value: '—',
            color: AppColors.primaryDark,
          ),
        ];
        return isWide
            ? Row(
                children: cards
                    .map(
                      (c) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: c,
                        ),
                      ),
                    )
                    .toList(),
              )
            : Column(
                children: cards
                    .map((c) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: c,
                        ))
                    .toList(),
              );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Action cards
// ═══════════════════════════════════════════════════════════

class _ActionCards extends StatelessWidget {
  final dynamic s;
  const _ActionCards({required this.s});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 500;
        Widget marketing = _ActionCard(
          gradient: AppColors.gradient,
          icon: Icons.insights_rounded,
          title: s.dashboardNewPlan,
          description: s.dashboardNewPlanDesc,
          onTap: () => context.push(AppRoutes.marketing),
        );
        Widget post = _ActionCard(
          gradient: const LinearGradient(
            colors: [Color(0xFF10B981), Color(0xFF059669)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          icon: Icons.edit_note_rounded,
          title: s.dashboardNewPost,
          description: s.dashboardNewPostDesc,
          onTap: () => context.push(AppRoutes.posts),
        );
        if (isWide) {
          return Row(
            children: [
              Expanded(child: marketing),
              const SizedBox(width: 16),
              Expanded(child: post),
            ],
          );
        }
        return Column(
          children: [
            marketing,
            const SizedBox(height: 12),
            post,
          ],
        );
      },
    );
  }
}

class _ActionCard extends StatelessWidget {
  final LinearGradient gradient;
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _ActionCard({
    required this.gradient,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.white, size: 22),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Recent reports placeholder
// ═══════════════════════════════════════════════════════════

class _RecentReportsPlaceholder extends StatelessWidget {
  final dynamic s;
  const _RecentReportsPlaceholder({required this.s});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.description_outlined,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            s.dashboardNoReports,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textMedium,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
