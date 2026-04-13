import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../checkout/presentation/pages/checkout_page.dart';
import '../providers/cart_providers.dart';
import '../widgets/book_cover_image.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cartItems = ref.watch(cartProvider);
    final subtotal = ref.watch(cartTotalProvider);
    final deliveryFee = cartItems.isEmpty ? 0.0 : 4.99;
    final total = subtotal + deliveryFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Padding(
                padding: AppSpacing.screenPadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 92,
                      height: 92,
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceSoft,
                        shape: BoxShape.circle,
                      ),
                      child: const AppIcon(
                        HugeIcons.strokeRoundedShoppingBag02,
                        size: 42,
                        color: AppColors.primary,
                      ),
                    ),
                    AppSpacing.gapLg,
                    Text(
                      'Your cart is feeling a little empty.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium,
                    ),
                    AppSpacing.gapSm,
                    Text(
                      'Add a few beautiful reads and they will show up here.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: AppSpacing.screenPadding,
              children: [
                ...cartItems.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusLg,
                        ),
                      ),
                      padding: AppSpacing.cardPadding,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 84,
                            height: 120,
                            child: BookCoverImage(
                              imageUrl: item.book.imageUrl,
                              borderRadius: AppSpacing.radiusMd,
                            ),
                          ),
                          AppSpacing.gapWmd,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.book.title,
                                  style: theme.textTheme.titleMedium,
                                ),
                                AppSpacing.gapXs,
                                Text(
                                  item.book.author,
                                  style: theme.textTheme.bodyMedium,
                                ),
                                AppSpacing.gapSm,
                                Text(
                                  '\$${item.book.price.toStringAsFixed(2)}',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                                AppSpacing.gapMd,
                                Row(
                                  children: [
                                    _QuantityButton(
                                      icon: Icons.remove,
                                      onPressed: () {
                                        ref
                                            .read(cartProvider.notifier)
                                            .updateQuantity(
                                              item.book.id,
                                              item.quantity - 1,
                                            );
                                      },
                                    ),
                                    Container(
                                      width: 42,
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${item.quantity}',
                                        style: theme.textTheme.titleMedium,
                                      ),
                                    ),
                                    _QuantityButton(
                                      icon: Icons.add,
                                      onPressed: item.quantity >= item.book.stock
                                          ? null
                                          : () {
                                              ref
                                                  .read(cartProvider.notifier)
                                                  .updateQuantity(
                                                    item.book.id,
                                                    item.quantity + 1,
                                                  );
                                            },
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () {
                                        ref
                                            .read(cartProvider.notifier)
                                            .removeItem(item.book.id);
                                      },
                                      icon: const AppIcon(
                                        HugeIcons.strokeRoundedDelete02,
                                      ),
                                      color: AppColors.error,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AppSpacing.gapSm,
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  ),
                  padding: AppSpacing.cardPadding,
                  child: Column(
                    children: [
                      _SummaryRow(
                        label: 'Subtotal',
                        value: '\$${subtotal.toStringAsFixed(2)}',
                      ),
                      AppSpacing.gapSm,
                      _SummaryRow(
                        label: 'Delivery',
                        value: '\$${deliveryFee.toStringAsFixed(2)}',
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                        child: Divider(height: 1),
                      ),
                      _SummaryRow(
                        label: 'Total',
                        value: '\$${total.toStringAsFixed(2)}',
                        emphasize: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: ElevatedButton(
          onPressed: cartItems.isEmpty
              ? null
              : () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const CheckoutPage(),
                    ),
                  );
                },
          child: Text(
            cartItems.isEmpty
                ? 'Add books to continue'
                : 'Checkout - \$${total.toStringAsFixed(2)}',
          ),
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      height: 34,
        child: OutlinedButton(
          onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
        ),
        child: AppIcon(
          icon == Icons.add
              ? HugeIcons.strokeRoundedPlusSign
              : HugeIcons.strokeRoundedMinusSign,
          size: 16,
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = emphasize
        ? theme.textTheme.titleMedium?.copyWith(color: AppColors.primaryDark)
        : theme.textTheme.bodyLarge;

    return Row(
      children: [
        Text(label, style: style),
        const Spacer(),
        Text(value, style: style),
      ],
    );
  }
}
