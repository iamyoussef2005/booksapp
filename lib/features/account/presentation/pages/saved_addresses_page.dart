import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../providers/account_providers.dart';

class SavedAddressesPage extends ConsumerWidget {
  const SavedAddressesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final addresses = ref.watch(savedAddressesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Addresses')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add_location_alt_outlined),
        label: const Text('Add Address'),
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          Text(
            'Delivery destinations',
            style: theme.textTheme.displayMedium,
          ),
          AppSpacing.gapSm,
          Text(
            'Keep your most-used shipping addresses ready for faster checkout.',
            style: theme.textTheme.bodyLarge,
          ),
          AppSpacing.gapLg,
          ...addresses.map(
            (address) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Container(
                padding: AppSpacing.cardPadding,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  border: address.isDefault
                      ? Border.all(color: Theme.of(context).colorScheme.primary)
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          address.label,
                          style: theme.textTheme.titleMedium,
                        ),
                        AppSpacing.gapWsm,
                        if (address.isDefault)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusXl,
                              ),
                            ),
                            child: Text(
                              'Default',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.edit_outlined),
                        ),
                      ],
                    ),
                    AppSpacing.gapSm,
                    Text(address.fullName, style: theme.textTheme.bodyLarge),
                    AppSpacing.gapXs,
                    Text(address.phoneNumber, style: theme.textTheme.bodyMedium),
                    AppSpacing.gapXs,
                    Text(
                      '${address.addressLine}, ${address.city}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
