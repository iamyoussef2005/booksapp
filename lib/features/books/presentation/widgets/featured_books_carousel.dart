import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../data/models/book_model.dart';
import 'book_cover_image.dart';

class FeaturedBooksCarousel extends StatefulWidget {
  const FeaturedBooksCarousel({super.key, required this.books, this.onBookTap});

  final List<BookModel> books;
  final ValueChanged<BookModel>? onBookTap;

  @override
  State<FeaturedBooksCarousel> createState() => _FeaturedBooksCarouselState();
}

class _FeaturedBooksCarouselState extends State<FeaturedBooksCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.books.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          height: 300,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.books.length,
            onPageChanged: (value) {
              setState(() => _currentPage = value);
            },
            itemBuilder: (context, index) {
              final book = widget.books[index];

              return Padding(
                padding: EdgeInsets.only(
                  right: index == widget.books.length - 1 ? 0 : AppSpacing.md,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => widget.onBookTap?.call(book),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusLg,
                        ),
                        gradient: const LinearGradient(
                          colors: [AppColors.primaryDark, AppColors.primary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 28,
                            offset: Offset(0, 16),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: AppSpacing.cardPadding,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.sm,
                                      vertical: AppSpacing.xs,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.surface.withValues(
                                        alpha: 0.18,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        AppSpacing.radiusXl,
                                      ),
                                    ),
                                    child: Text(
                                      'Featured',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(color: AppColors.surface),
                                    ),
                                  ),
                                  AppSpacing.gapMd,
                                  Text(
                                    book.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.headlineMedium
                                        ?.copyWith(color: AppColors.surface),
                                  ),
                                  AppSpacing.gapXs,
                                  Text(
                                    book.author,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: AppColors.surface.withValues(
                                        alpha: 0.84,
                                      ),
                                    ),
                                  ),
                                  AppSpacing.gapSm,
                                  Text(
                                    book.description,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: AppColors.surface.withValues(
                                        alpha: 0.75,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '\$${book.price.toStringAsFixed(2)}',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      color: AppColors.surface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AppSpacing.gapWmd,
                            Expanded(
                              flex: 3,
                              child: BookCoverImage(
                                imageUrl: book.imageUrl,
                                borderRadius: AppSpacing.radiusMd,
                                fit: BoxFit.cover,
                                heroTag: 'book-${book.id}',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        AppSpacing.gapMd,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.books.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
              height: 8,
              width: _currentPage == index ? 26 : 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? AppColors.primary
                    : AppColors.border,
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
