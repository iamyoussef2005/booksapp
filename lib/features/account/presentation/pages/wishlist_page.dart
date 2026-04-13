import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../books/presentation/pages/book_details_page.dart';
import '../../../books/presentation/widgets/book_grid_card.dart';
import '../providers/account_providers.dart';

class WishlistPage extends ConsumerWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final wishlist = ref.watch(wishlistProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: wishlist.isEmpty
          ? Center(
              child: Padding(
                padding: AppSpacing.screenPadding,
                child: Text(
                  'Your wishlist is empty for now.',
                  style: theme.textTheme.titleMedium,
                ),
              ),
            )
          : CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: AppSpacing.screenPadding,
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saved reads for later',
                          style: theme.textTheme.displayMedium,
                        ),
                        AppSpacing.gapSm,
                        Text(
                          'Books you bookmarked because they looked too good to lose.',
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
                              const Icon(
                                Icons.favorite_rounded,
                                color: AppColors.accent,
                              ),
                              AppSpacing.gapWsm,
                              Expanded(
                                child: Text(
                                  '${wishlist.length} books waiting in your wishlist',
                                  style: theme.textTheme.bodyLarge,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    0,
                    AppSpacing.lg,
                    AppSpacing.xl,
                  ),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final book = wishlist[index];
                        return BookGridCard(
                          book: book,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => BookDetailsPage(book: book),
                              ),
                            );
                          },
                        );
                      },
                      childCount: wishlist.length,
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: AppSpacing.md,
                      crossAxisSpacing: AppSpacing.md,
                      childAspectRatio: 0.56,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
