import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../account/presentation/pages/order_history_page.dart';
import '../../../account/presentation/providers/account_providers.dart';
import '../../../books/presentation/pages/books_home_page.dart';

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({
    super.key,
    required this.order,
  });

  final OrderHistoryItem order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 108,
                    height: 108,
                    decoration: BoxDecoration(
                      color: const Color(0x1A527A5A),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: AppIcon(
                        HugeIcons.strokeRoundedShoppingBasketCheckOut03,
                        color: AppColors.success,
                        size: 52,
                      ),
                    ),
                  ),
                  AppSpacing.gapLg,
                  Text(
                    'Order placed successfully',
                    style: theme.textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.gapSm,
                  Text(
                    'Order ${order.id} is confirmed. Your books are being prepared and will appear in your order history.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge,
                  ),
                  AppSpacing.gapLg,
                  Container(
                    padding: AppSpacing.cardPadding,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    ),
                    child: Column(
                      children: [
                        _InfoRow(label: 'Status', value: order.status),
                        AppSpacing.gapSm,
                        _InfoRow(label: 'Items', value: '${order.itemsCount}'),
                        AppSpacing.gapSm,
                        _InfoRow(
                          label: 'Total',
                          value: '\$${order.total.toStringAsFixed(2)}',
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.gapLg,
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute<void>(
                            builder: (_) => const BooksHomePage(),
                          ),
                          (route) => false,
                        );
                      },
                      child: const Text('Continue Shopping'),
                    ),
                  ),
                  AppSpacing.gapSm,
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute<void>(
                            builder: (_) => const OrderHistoryPage(),
                          ),
                        );
                      },
                      child: const Text('View Order History'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primaryDark,
              ),
        ),
      ],
    );
  }
}
