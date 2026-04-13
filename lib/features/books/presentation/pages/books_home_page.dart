import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../account/presentation/pages/account_page.dart';
import '../../data/models/book_model.dart';
import '../providers/book_search_providers.dart';
import '../providers/books_home_providers.dart';
import '../providers/cart_providers.dart';
import '../widgets/book_grid_card.dart';
import '../widgets/featured_books_carousel.dart';
import 'cart_page.dart';
import 'book_details_page.dart';

class BooksHomePage extends ConsumerStatefulWidget {
  const BooksHomePage({super.key});

  @override
  ConsumerState<BooksHomePage> createState() => _BooksHomePageState();
}

class _BooksHomePageState extends ConsumerState<BooksHomePage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openBookDetails(BuildContext context, BookModel book) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => BookDetailsPage(book: book)),
    );
  }

  void _openCart(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const CartPage()));
  }

  void _openAccount(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const AccountPage()));
  }

  void _applySuggestion(String suggestion) {
    _searchController.value = TextEditingValue(
      text: suggestion,
      selection: TextSelection.collapsed(offset: suggestion.length),
    );
    ref.read(bookSearchProvider.notifier).applySuggestion(suggestion);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = ref.watch(categoriesProvider);
    final searchState = ref.watch(bookSearchProvider);
    final featuredBooks = ref.watch(featuredBooksProvider);
    final books = searchState.results;
    final cartCount = ref.watch(cartItemCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Shop'),
        actions: [
          IconButton(
            onPressed: () => _openAccount(context),
            icon: const CircleAvatar(
              radius: 15,
              backgroundColor: AppColors.surfaceSoft,
              child: Text(
                'AT',
                style: TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () => _openCart(context),
            icon: Badge.count(
              count: cartCount,
              isLabelVisible: cartCount > 0,
              child: const AppIcon(HugeIcons.strokeRoundedShoppingBag02),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: AppSpacing.screenPadding,
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  'Find your next favorite book',
                  style: theme.textTheme.displayMedium,
                ),
                AppSpacing.gapSm,
                Text(
                  'Browse handpicked stories, warm recommendations, and today\'s featured reads.',
                  style: theme.textTheme.bodyLarge,
                ),
                AppSpacing.gapLg,
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    ref.read(bookSearchProvider.notifier).updateQuery(value);
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(12),
                      child: AppIcon(HugeIcons.strokeRoundedSearch02, size: 20),
                    ),
                    suffixIcon: searchState.query.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: AppIcon(
                              HugeIcons.strokeRoundedFilterHorizontal,
                              size: 20,
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              _searchController.clear();
                              ref.read(bookSearchProvider.notifier).clear();
                            },
                            icon: const AppIcon(
                              HugeIcons.strokeRoundedCancel01,
                            ),
                          ),
                    hintText: 'Search books, authors, genres',
                  ),
                ),
                if (searchState.suggestions.isNotEmpty) ...[
                  AppSpacing.gapMd,
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Featured Books',
                          style: theme.textTheme.headlineMedium,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('See all'),
                      ),
                    ],
                  ),
                  AppSpacing.gapMd,
                  FeaturedBooksCarousel(
                    books: featuredBooks,
                    onBookTap: (book) => _openBookDetails(context, book),
                  ),
                  AppSpacing.gapXl,
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final suggestion = searchState.suggestions[index];

                          return ActionChip(
                            label: Text(suggestion),
                            avatar: const AppIcon(
                              HugeIcons.strokeRoundedArrowUpRight01,
                              size: 16,
                            ),
                            onPressed: () => _applySuggestion(suggestion),
                          );
                      },
                      separatorBuilder: (context, index) => AppSpacing.gapWsm,
                      itemCount: searchState.suggestions.length,
                    ),
                  ),
                ],

                AppSpacing.gapMd,
                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected =
                          category == searchState.selectedCategory;

                      return ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (_) {
                          ref
                              .read(bookSearchProvider.notifier)
                              .updateCategory(category);
                        },
                      );
                    },
                    separatorBuilder: (context, index) => AppSpacing.gapWsm,
                    itemCount: categories.length,
                  ),
                ),
                AppSpacing.gapXl,

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Browse Collection',
                        style: theme.textTheme.headlineMedium,
                      ),
                    ),
                    Row(
                      children: [
                        PopupMenuButton<double>(
                          tooltip: 'Minimum rating',
                          onSelected: (rating) {
                            ref
                                .read(bookSearchProvider.notifier)
                                .updateMinimumRating(rating);
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(value: 0, child: Text('All ratings')),
                            PopupMenuItem(value: 4, child: Text('4.0+')),
                            PopupMenuItem(value: 4.5, child: Text('4.5+')),
                            PopupMenuItem(value: 4.8, child: Text('4.8+')),
                          ],
                          child: Container(
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
                                    HugeIcons.strokeRoundedStarHalf,
                                    size: 16,
                                    color: AppColors.warning,
                                  ),
                                  AppSpacing.gapWxs,
                                  Text(
                                  searchState.minimumRating == 0
                                      ? 'All ratings'
                                      : '${searchState.minimumRating.toStringAsFixed(1)}+',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        AppSpacing.gapWsm,
                        Text(
                          '${books.length} books',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
                AppSpacing.gapMd,
                if (searchState.isSearching)
                  const LinearProgressIndicator(
                    minHeight: 2,
                    color: AppColors.primary,
                    backgroundColor: AppColors.border,
                  ),
                if (searchState.isSearching) AppSpacing.gapMd,
                if (books.isEmpty)
                  Container(
                    padding: AppSpacing.cardPadding,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    ),
                    child: Column(
                        children: [
                          const AppIcon(
                            HugeIcons.strokeRoundedBookOpen02,
                            size: 44,
                            color: AppColors.primary,
                          ),
                          AppSpacing.gapMd,
                          Text(
                          'No books match your search yet.',
                          style: theme.textTheme.titleMedium,
                        ),
                        AppSpacing.gapXs,
                        Text(
                          'Try a different title, author, category, or rating filter.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
              ]),
            ),
          ),
          if (books.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => BookGridCard(
                    book: books[index],
                    onTap: () => _openBookDetails(context, books[index]),
                  ),
                  childCount: books.length,
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
