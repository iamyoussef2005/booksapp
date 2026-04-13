import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../books/presentation/widgets/book_cover_image.dart';
import '../providers/account_providers.dart';

class OrderHistoryPage extends ConsumerWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final orders = ref.watch(orderHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          Text(
            'Your recent orders',
            style: theme.textTheme.displayMedium,
          ),
          AppSpacing.gapSm,
          Text(
            'A quick view of what you bought, when it shipped, and what it cost.',
            style: theme.textTheme.bodyLarge,
          ),
          AppSpacing.gapLg,
          ...orders.map(
            (order) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Container(
                padding: AppSpacing.cardPadding,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(order.id, style: theme.textTheme.titleMedium),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: order.status == 'Delivered'
                                ? const Color(0x1A527A5A)
                                : order.status == 'Confirmed'
                                    ? const Color(0x1AB86A3A)
                                    : const Color(0x1AD29A4A),
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusXl,
                            ),
                          ),
                          child: Text(
                            order.status,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: order.status == 'Delivered'
                                  ? AppColors.success
                                  : order.status == 'Confirmed'
                                      ? AppColors.primary
                                      : AppColors.warning,
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.gapXs,
                    Text(order.dateLabel, style: theme.textTheme.bodyMedium),
                    AppSpacing.gapMd,
                    SizedBox(
                      height: 88,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final book = order.books[index];
                          return SizedBox(
                            width: 62,
                            child: BookCoverImage(
                              imageUrl: book.imageUrl,
                              borderRadius: AppSpacing.radiusMd,
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            AppSpacing.gapWsm,
                        itemCount: order.books.length,
                      ),
                    ),
                    AppSpacing.gapMd,
                    Row(
                      children: [
                        Text(
                          '${order.itemsCount} items',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const Spacer(),
                        Text(
                          '\$${order.total.toStringAsFixed(2)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
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
