import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_settings_provider.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/account_providers.dart';
import 'order_history_page.dart';
import 'saved_addresses_page.dart';
import 'wishlist_page.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settings = ref.watch(appSettingsProvider).valueOrNull ??
        const AppSettings();
    final auth = ref.watch(authProvider).valueOrNull ?? const AuthState();
    final user = auth.user;
    final orders = ref.watch(orderHistoryProvider);
    final wishlist = ref.watch(wishlistProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          Container(
            padding: AppSpacing.cardPadding,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  AppColors.primaryDark,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _initialsFor(user?.fullName ?? 'Aseel T.'),
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    AppSpacing.gapWmd,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.fullName ?? 'Aseel T.',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          AppSpacing.gapXs,
                          Text(
                            user?.email ?? 'aseel.reader@example.com',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.82),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapLg,
                Text(
                  'Book Club Member since 2026',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.82),
                  ),
                ),
                AppSpacing.gapMd,
                Row(
                  children: [
                    Expanded(
                      child: _ProfileStat(
                        label: 'Orders',
                        value: '${orders.length}',
                      ),
                    ),
                    Expanded(
                      child: _ProfileStat(
                        label: 'Wishlist',
                        value: '${wishlist.length}',
                      ),
                    ),
                    const Expanded(
                      child: _ProfileStat(label: 'Reviews', value: '8'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppSpacing.gapLg,
          Text(
            'Account',
            style: theme.textTheme.headlineMedium,
          ),
          AppSpacing.gapSm,
          _SectionCard(
            children: [
              _ActionTile(
                icon: Icons.receipt_long_rounded,
                title: 'Order History',
                subtitle: 'Track purchases and download invoices',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const OrderHistoryPage(),
                    ),
                  );
                },
              ),
              const _ActionDivider(),
              _ActionTile(
                icon: Icons.favorite_border_rounded,
                title: 'Wishlist',
                subtitle: 'Saved books for later',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const WishlistPage(),
                    ),
                  );
                },
              ),
              const _ActionDivider(),
              _ActionTile(
                icon: Icons.location_on_outlined,
                title: 'Saved Addresses',
                subtitle: 'Manage shipping addresses',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const SavedAddressesPage(),
                    ),
                  );
                },
              ),
              const _ActionDivider(),
              const _ActionTile(
                icon: Icons.credit_card_outlined,
                title: 'Payment Methods',
                subtitle: 'Cards and checkout preferences',
              ),
              const _ActionDivider(),
              _ActionTile(
                icon: Icons.logout_rounded,
                title: 'Sign Out',
                subtitle: 'Leave the mock session and return to auth',
                onTap: () async {
                  await ref.read(authProvider.notifier).signOut();
                },
              ),
            ],
          ),
          AppSpacing.gapLg,
          Text(
            'Preferences',
            style: theme.textTheme.headlineMedium,
          ),
          AppSpacing.gapSm,
          _SectionCard(
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Dark Mode'),
                subtitle: const Text('Use a darker reading atmosphere'),
                value: settings.themeMode == ThemeMode.dark,
                onChanged: (value) {
                  ref
                      .read(appSettingsProvider.notifier)
                      .toggleThemeMode(value);
                },
              ),
              const _ActionDivider(),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Notifications'),
                subtitle: const Text('New arrivals, offers, and order updates'),
                value: settings.notificationsEnabled,
                onChanged: (value) {
                  ref
                      .read(appSettingsProvider.notifier)
                      .toggleNotifications(value);
                },
              ),
              const _ActionDivider(),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Reading Reminders'),
                subtitle: const Text('Gentle nudges to return to your reading list'),
                value: settings.readingRemindersEnabled,
                onChanged: (value) {
                  ref
                      .read(appSettingsProvider.notifier)
                      .toggleReadingReminders(value);
                },
              ),
              const _ActionDivider(),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Download on Wi-Fi Only'),
                subtitle: const Text('Best for syncing covers and samples'),
                value: settings.downloadOnWifiOnly,
                onChanged: (value) {
                  ref
                      .read(appSettingsProvider.notifier)
                      .toggleDownloadOnWifiOnly(value);
                },
              ),
            ],
          ),
          AppSpacing.gapLg,
          Text(
            'More',
            style: theme.textTheme.headlineMedium,
          ),
          AppSpacing.gapSm,
          _SectionCard(
            children: const [
              _ActionTile(
                icon: Icons.language_rounded,
                title: 'Language & Region',
                subtitle: 'English, Arabic, currency, and locale',
              ),
              _ActionDivider(),
              _ActionTile(
                icon: Icons.help_outline_rounded,
                title: 'Help & Support',
                subtitle: 'FAQs, contact, and bookstore policies',
              ),
              _ActionDivider(),
              _ActionTile(
                icon: Icons.info_outline_rounded,
                title: 'About This App',
                subtitle: 'Version, stack, and project highlights',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _initialsFor(String name) {
  final parts = name
      .trim()
      .split(' ')
      .where((part) => part.isNotEmpty)
      .take(2)
      .toList();

  if (parts.isEmpty) {
    return 'R';
  }

  return parts.map((part) => part[0].toUpperCase()).join();
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        AppSpacing.gapXs,
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.78),
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(children: children),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(title, style: theme.textTheme.titleMedium),
      subtitle: Text(subtitle, style: theme.textTheme.bodyMedium),
      trailing: const Icon(Icons.chevron_right_rounded, size: 18),
      onTap: onTap,
    );
  }
}

class _ActionDivider extends StatelessWidget {
  const _ActionDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Divider(height: 1),
    );
  }
}
