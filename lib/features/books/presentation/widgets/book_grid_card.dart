import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../data/models/book_model.dart';
import 'book_cover_image.dart';

class BookGridCard extends StatelessWidget {
  const BookGridCard({
    super.key,
    required this.book,
    this.onTap,
  });

  final BookModel book;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: BookCoverImage(
                        imageUrl: book.imageUrl,
                        borderRadius: AppSpacing.radiusMd,
                        heroTag: 'book-${book.id}',
                      ),
                    ),
                    Positioned(
                      top: AppSpacing.xs,
                      right: AppSpacing.xs,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                          vertical: AppSpacing.xxs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusXl,
                          ),
                        ),
                        child: Row(
                          children: [
                            const AppIcon(
                              HugeIcons.strokeRoundedStar,
                              size: 14,
                              color: AppColors.warning,
                            ),
                            AppSpacing.gapWxs,
                            Text(
                              book.rating.toStringAsFixed(1),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.gapMd,
              Text(
                book.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium,
              ),
              AppSpacing.gapXs,
              Text(
                book.author,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium,
              ),
              AppSpacing.gapSm,
              Row(
                children: [
                  Text(
                    '\$${book.price.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const Spacer(),
                  AppIcon(
                    book.stock > 0
                        ? HugeIcons.strokeRoundedShoppingBagCheck
                        : HugeIcons.strokeRoundedCancelCircle,
                    size: 18,
                    color: book.stock > 0 ? AppColors.success : AppColors.error,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
