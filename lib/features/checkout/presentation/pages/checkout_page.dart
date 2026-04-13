import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../account/presentation/providers/account_providers.dart';
import '../../../books/presentation/providers/cart_providers.dart';
import '../../../books/presentation/widgets/book_cover_image.dart';
import 'order_success_page.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  String? _selectedAddressId;
  String? _selectedPaymentMethodId;
  bool _isPlacingOrder = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cartItems = ref.watch(cartProvider);
    final addresses = ref.watch(savedAddressesProvider);
    final paymentMethods = ref.watch(paymentMethodsProvider);
    final subtotal = ref.watch(cartTotalProvider);
    const deliveryFee = 4.99;
    final total = subtotal + deliveryFee;

    _selectedAddressId ??= addresses.firstWhere((item) => item.isDefault).id;
    _selectedPaymentMethodId ??=
        paymentMethods.firstWhere((item) => item.isDefault).id;

    final selectedAddress = addresses.firstWhere(
      (item) => item.id == _selectedAddressId,
    );
    final selectedPaymentMethod = paymentMethods.firstWhere(
      (item) => item.id == _selectedPaymentMethodId,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          Text(
            'Review and place your order',
            style: theme.textTheme.displayMedium,
          ),
          AppSpacing.gapSm,
          Text(
            'One last look before your next stack of books heads your way.',
            style: theme.textTheme.bodyLarge,
          ),
          AppSpacing.gapLg,
          _SectionCard(
            title: 'Delivery Address',
            icon: HugeIcons.strokeRoundedMapPin,
            child: Column(
              children: [
                for (final address in addresses)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _SelectionTile(
                      title: address.label,
                      subtitle:
                          '${address.addressLine}, ${address.city}\n${address.phoneNumber}',
                      isSelected: _selectedAddressId == address.id,
                      onTap: () {
                        setState(() => _selectedAddressId = address.id);
                      },
                    ),
                  ),
              ],
            ),
          ),
          AppSpacing.gapLg,
          _SectionCard(
            title: 'Payment Method',
            icon: HugeIcons.strokeRoundedCreditCard,
            child: Column(
              children: [
                for (final method in paymentMethods)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _SelectionTile(
                      title: method.label,
                      subtitle: method.subtitle,
                      isSelected: _selectedPaymentMethodId == method.id,
                      onTap: () {
                        setState(() => _selectedPaymentMethodId = method.id);
                      },
                    ),
                  ),
              ],
            ),
          ),
          AppSpacing.gapLg,
          _SectionCard(
            title: 'Order Summary',
            icon: HugeIcons.strokeRoundedInvoice01,
            child: Column(
              children: [
                ...cartItems.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 48,
                          height: 68,
                          child: BookCoverImage(
                            imageUrl: item.book.imageUrl,
                            borderRadius: AppSpacing.radiusSm,
                          ),
                        ),
                        AppSpacing.gapWsm,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.book.title,
                                style: theme.textTheme.titleMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              AppSpacing.gapXs,
                              Text(
                                '${item.quantity} x \$${item.book.price.toStringAsFixed(2)}',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '\$${item.totalPrice.toStringAsFixed(2)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1),
                AppSpacing.gapMd,
                _SummaryRow(
                  label: 'Subtotal',
                  value: '\$${subtotal.toStringAsFixed(2)}',
                ),
                AppSpacing.gapSm,
                const _SummaryRow(
                  label: 'Delivery',
                  value: '\$4.99',
                ),
                AppSpacing.gapSm,
                _SummaryRow(
                  label: 'Total',
                  value: '\$${total.toStringAsFixed(2)}',
                  emphasize: true,
                ),
              ],
            ),
          ),
          AppSpacing.gapLg,
          Container(
            padding: AppSpacing.cardPadding,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Delivery to', style: theme.textTheme.titleMedium),
                AppSpacing.gapXs,
                Text(
                  '${selectedAddress.label} • ${selectedAddress.fullName}',
                  style: theme.textTheme.bodyLarge,
                ),
                AppSpacing.gapXs,
                Text(
                  'Paying with ${selectedPaymentMethod.label}',
                  style: theme.textTheme.bodyMedium,
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
          onPressed: cartItems.isEmpty || _isPlacingOrder
              ? null
              : () async {
                  setState(() => _isPlacingOrder = true);
                  await Future<void>.delayed(const Duration(milliseconds: 700));

                  final order = ref
                      .read(orderHistoryProvider.notifier)
                      .placeOrder(cartItems: cartItems, total: total);
                  ref.read(cartProvider.notifier).clearCart();

                  if (!context.mounted) {
                    return;
                  }

                  await Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (_) => OrderSuccessPage(order: order),
                    ),
                  );
                },
          child: _isPlacingOrder
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text('Place Order - \$${total.toStringAsFixed(2)}'),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final List<List<dynamic>> icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
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
              AppIcon(icon, color: AppColors.primaryDark, size: 18),
              AppSpacing.gapWsm,
              Text(title, style: theme.textTheme.titleMedium),
            ],
          ),
          AppSpacing.gapMd,
          child,
        ],
      ),
    );
  }
}

class _SelectionTile extends StatelessWidget {
  const _SelectionTile({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: isSelected ? AppColors.surfaceSoft : Colors.transparent,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium),
                    AppSpacing.gapXs,
                    Text(subtitle, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
              AppSpacing.gapWsm,
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: 2,
                  ),
                  color: isSelected ? AppColors.primary : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
            ],
          ),
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
