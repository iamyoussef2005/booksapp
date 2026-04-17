import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../account/presentation/providers/account_providers.dart';
import '../../data/models/book_model.dart';
import '../providers/cart_providers.dart';
import '../widgets/book_cover_image.dart';

class BookDetailsPage extends ConsumerStatefulWidget {
  const BookDetailsPage({
    super.key,
    required this.book,
  });

  final BookModel book;

  @override
  ConsumerState<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends ConsumerState<BookDetailsPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _heroTextSlide;
  late final Animation<Offset> _detailsSlide;
  late final Animation<double> _buttonScale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _heroTextSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.05, 0.55, curve: Curves.easeOutCubic),
      ),
    );
    _detailsSlide = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.82, curve: Curves.easeOutCubic),
      ),
    );
    _buttonScale = Tween<double>(
      begin: 0.94,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 1, curve: Curves.elasticOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final book = widget.book;
    final isWishlisted = ref.watch(isInWishlistProvider(book.id));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 420,
            backgroundColor: AppColors.background,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const AppIcon(HugeIcons.strokeRoundedArrowLeft01),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  ref.read(wishlistIdsProvider.notifier).toggle(book.id);
                },
                icon: AppIcon(
                  HugeIcons.strokeRoundedFavourite,
                  color: isWishlisted ? AppColors.accent : null,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const AppIcon(HugeIcons.strokeRoundedShare01),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFEAD8C7), AppColors.background],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    left: -40,
                    top: 40,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0x35FFFFFF),
                      ),
                    ),
                  ),
                  Positioned(
                    right: -20,
                    bottom: 40,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0x30FFFFFF),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: AppSpacing.screenPadding,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _heroTextSlide,
                          child: Column(
                            children: [
                              const Spacer(),
                              SizedBox(
                                height: 255,
                                child: Center(
                                  child: AspectRatio(
                                    aspectRatio: 0.72,
                                    child: BookCoverImage(
                                      imageUrl: book.imageUrl,
                                      heroTag: 'book-${book.id}',
                                      borderRadius: AppSpacing.radiusLg,
                                    ),
                                  ),
                                ),
                              ),
                              AppSpacing.gapLg,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _detailsSlide,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.lg,
                    120,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSoft,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusXl,
                          ),
                        ),
                        child: Text(
                          book.category,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                      AppSpacing.gapMd,
                      Text(
                        book.title,
                        style: theme.textTheme.displayMedium,
                      ),
                      AppSpacing.gapXs,
                      Text(
                        'By ${book.author}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      AppSpacing.gapMd,
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusXl,
                              ),
                            ),
                            child: Row(
                              children: [
                                const AppIcon(
                                  HugeIcons.strokeRoundedStar,
                                  color: AppColors.warning,
                                  size: 18,
                                ),
                                AppSpacing.gapWxs,
                                Text(
                                  book.rating.toStringAsFixed(1),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AppSpacing.gapWsm,
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: book.stock > 0
                                  ? const Color(0x1A527A5A)
                                  : const Color(0x1AB65454),
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusXl,
                              ),
                            ),
                            child: Text(
                              book.stock > 0
                                  ? '${book.stock} in stock'
                                  : 'Out of stock',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: book.stock > 0
                                    ? AppColors.success
                                    : AppColors.error,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '\$${book.price.toStringAsFixed(2)}',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.gapXl,
                      Text(
                        'Description',
                        style: theme.textTheme.headlineMedium,
                      ),
                      AppSpacing.gapSm,
                      Text(
                        book.description,
                        style: theme.textTheme.bodyLarge,
                      ),
                      AppSpacing.gapLg,
                      Container(
                        padding: AppSpacing.cardPadding,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusLg,
                          ),
                        ),
                        child: Row(
                          children: [
                            const AppIcon(
                              HugeIcons.strokeRoundedShoppingBagCheck,
                              color: AppColors.primary,
                            ),
                            AppSpacing.gapWsm,
                            Expanded(
                              child: Text(
                                'Free delivery on orders over \$35 and gift wrapping available.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
        child: ScaleTransition(
          scale: _buttonScale,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ref.read(wishlistIdsProvider.notifier).toggle(book.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isWishlisted
                              ? '${book.title} removed from wishlist'
                              : '${book.title} saved to wishlist',
                        ),
                      ),
                    );
                  },
                  icon: AppIcon(
                    HugeIcons.strokeRoundedFavourite,
                    color: isWishlisted ? AppColors.accent : AppColors.primary,
                  ),
                  label: Text(
                    isWishlisted
                        ? 'Remove from Wishlist'
                        : 'Save to Wishlist',
                  ),
                ),
              ),
              AppSpacing.gapSm,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: book.stock > 0
                      ? () {
                          ref.read(cartProvider.notifier).addItem(book);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${book.title} added to cart'),
                            ),
                          );
                        }
                      : null,
                  icon: const AppIcon(HugeIcons.strokeRoundedShoppingBagAdd),
                  label: const Text('Add to Cart'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
