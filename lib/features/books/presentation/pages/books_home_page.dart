import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../core/widgets/app_state_view.dart';
import '../../../../core/widgets/app_user_avatar.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/book_model.dart';
import '../providers/book_search_providers.dart';
import '../providers/books_home_providers.dart';
import '../providers/cart_providers.dart';
import '../widgets/book_grid_card.dart';
import '../widgets/featured_books_carousel.dart';
import 'book_details_page.dart';

class BooksHomePage extends ConsumerStatefulWidget {
  const BooksHomePage({super.key, this.onOpenCart, this.onOpenAccount});

  final VoidCallback? onOpenCart;
  final VoidCallback? onOpenAccount;

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

  void _applySuggestion(String suggestion) {
    _searchController.value = TextEditingValue(
      text: suggestion,
      selection: TextSelection.collapsed(offset: suggestion.length),
    );
    ref.read(bookSearchProvider.notifier).applySuggestion(suggestion);
  }

  void _clearAllFilters() {
    _searchController.clear();
    ref.read(bookSearchProvider.notifier).clearAllFilters();
  }

  Widget _buildCollectionControls({
    required BuildContext context,
    required ThemeData theme,
    required BookSearchState searchState,
    required int bookCount,
  }) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        PopupMenuButton<BookSortOption>(
          tooltip: 'Sort books',
          onSelected: (sortOption) {
            ref.read(bookSearchProvider.notifier).updateSortOption(sortOption);
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: BookSortOption.relevance,
              child: Text('Relevance'),
            ),
            PopupMenuItem(
              value: BookSortOption.popularity,
              child: Text('Popularity'),
            ),
            PopupMenuItem(value: BookSortOption.newest, child: Text('Newest')),
            PopupMenuItem(value: BookSortOption.rating, child: Text('Rating')),
            PopupMenuItem(
              value: BookSortOption.priceLowToHigh,
              child: Text('Price'),
            ),
          ],
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.swap_vert_rounded,
                  size: 16,
                  color: AppColors.primaryDark,
                ),
                AppSpacing.gapWxs,
                Text(
                  _sortLabel(searchState.sortOption),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        PopupMenuButton<double>(
          tooltip: 'Minimum rating',
          onSelected: (rating) {
            ref.read(bookSearchProvider.notifier).updateMinimumRating(rating);
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
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
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
        Text('$bookCount books', style: theme.textTheme.bodyMedium),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = ref.watch(categoriesProvider);
    final searchState = ref.watch(bookSearchProvider);
    final featuredBooks = ref.watch(featuredBooksProvider);
    final books = searchState.results;
    final cartCount = ref.watch(cartItemCountProvider);
    final user = ref.watch(authProvider).valueOrNull?.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Shop'),
        actions: [
          IconButton(
            onPressed: widget.onOpenAccount,
            icon: AppUserAvatar(fullName: user?.fullName, email: user?.email),
          ),
          IconButton(
            onPressed: widget.onOpenCart,
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

                if (_hasActiveFilters(searchState)) ...[
                  AppSpacing.gapMd,
                  Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: [
                            if (searchState.query.isNotEmpty)
                              Chip(label: Text('Search: ${searchState.query}')),
                            if (searchState.selectedCategory !=
                                allCategoryFilter)
                              Chip(label: Text(searchState.selectedCategory)),
                            if (searchState.minimumRating > 0)
                              Chip(
                                label: Text(
                                  'Rating ${searchState.minimumRating.toStringAsFixed(1)}+',
                                ),
                              ),
                            if (searchState.sortOption !=
                                BookSortOption.relevance)
                              Chip(
                                label: Text(
                                  'Sort: ${_sortLabel(searchState.sortOption)}',
                                ),
                              ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: _clearAllFilters,
                        child: const Text('Clear all'),
                      ),
                    ],
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

                LayoutBuilder(
                  builder: (context, constraints) {
                    final controls = _buildCollectionControls(
                      context: context,
                      theme: theme,
                      searchState: searchState,
                      bookCount: books.length,
                    );

                    if (constraints.maxWidth < 460) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Browse Collection',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.headlineMedium,
                          ),
                          AppSpacing.gapSm,
                          controls,
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Browse Collection',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.headlineMedium,
                          ),
                        ),
                        AppSpacing.gapWmd,
                        Flexible(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: controls,
                          ),
                        ),
                      ],
                    );
                  },
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
                  const AppEmptyState(
                    icon: AppIcon(
                      HugeIcons.strokeRoundedBookOpen02,
                      size: 44,
                      color: AppColors.primary,
                    ),
                    title: 'No books match your search yet.',
                    message:
                        'Try a different title, author, category, or rating filter.',
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

  bool _hasActiveFilters(BookSearchState state) {
    return state.query.isNotEmpty ||
        state.selectedCategory != allCategoryFilter ||
        state.minimumRating > 0 ||
        state.sortOption != BookSortOption.relevance;
  }

  String _sortLabel(BookSortOption sortOption) {
    switch (sortOption) {
      case BookSortOption.relevance:
        return 'Relevance';
      case BookSortOption.popularity:
        return 'Popularity';
      case BookSortOption.newest:
        return 'Newest';
      case BookSortOption.rating:
        return 'Rating';
      case BookSortOption.priceLowToHigh:
        return 'Price';
    }
  }
}
