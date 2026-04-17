import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/book_model.dart';
import 'books_home_providers.dart';

const allCategoryFilter = 'All';

enum BookSortOption {
  relevance,
  popularity,
  newest,
  rating,
  priceLowToHigh,
}

class BookSearchState {
  const BookSearchState({
    this.query = '',
    this.selectedCategory = allCategoryFilter,
    this.minimumRating = 0,
    this.sortOption = BookSortOption.relevance,
    this.results = const [],
    this.suggestions = const [],
    this.isSearching = false,
  });

  final String query;
  final String selectedCategory;
  final double minimumRating;
  final BookSortOption sortOption;
  final List<BookModel> results;
  final List<String> suggestions;
  final bool isSearching;

  BookSearchState copyWith({
    String? query,
    String? selectedCategory,
    double? minimumRating,
    BookSortOption? sortOption,
    List<BookModel>? results,
    List<String>? suggestions,
    bool? isSearching,
  }) {
    return BookSearchState(
      query: query ?? this.query,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      minimumRating: minimumRating ?? this.minimumRating,
      sortOption: sortOption ?? this.sortOption,
      results: results ?? this.results,
      suggestions: suggestions ?? this.suggestions,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}

class BookSearchNotifier extends AutoDisposeNotifier<BookSearchState> {
  Timer? _debounce;

  @override
  BookSearchState build() {
    ref.onDispose(() => _debounce?.cancel());
    final books = ref.watch(booksProvider);
    return BookSearchState(
      results: books,
      suggestions: _buildSuggestions(books, ''),
    );
  }

  void updateQuery(String query) {
    final normalizedQuery = query.trimLeft();
    state = state.copyWith(
      query: normalizedQuery,
      isSearching: true,
      suggestions: _buildSuggestions(ref.read(booksProvider), normalizedQuery),
    );

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), _applySearch);
  }

  void updateCategory(String category) {
    state = state.copyWith(selectedCategory: category, isSearching: true);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 150), _applySearch);
  }

  void updateMinimumRating(double rating) {
    state = state.copyWith(minimumRating: rating, isSearching: true);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 150), _applySearch);
  }

  void applySuggestion(String suggestion) {
    state = state.copyWith(query: suggestion, isSearching: true);
    _debounce?.cancel();
    _applySearch();
  }

  void updateSortOption(BookSortOption sortOption) {
    state = state.copyWith(sortOption: sortOption, isSearching: true);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 100), _applySearch);
  }

  void clear() {
    _debounce?.cancel();
    final books = ref.read(booksProvider);
    state = BookSearchState(
      results: books,
      suggestions: _buildSuggestions(books, ''),
    );
  }

  void clearAllFilters() {
    clear();
  }

  void _applySearch() {
    final books = ref.read(booksProvider);
    final results = _filterBooks(
      books: books,
      query: state.query,
      category: state.selectedCategory,
      minimumRating: state.minimumRating,
      sortOption: state.sortOption,
    );

    state = state.copyWith(
      results: results,
      suggestions: _buildSuggestions(books, state.query),
      isSearching: false,
    );
  }

  List<BookModel> _filterBooks({
    required List<BookModel> books,
    required String query,
    required String category,
    required double minimumRating,
    required BookSortOption sortOption,
  }) {
    final normalizedQuery = query.trim().toLowerCase();
    final filtered = books.where((book) {
      final matchesCategory =
          category == allCategoryFilter || book.category == category;
      final matchesRating = book.rating >= minimumRating;
      final matchesQuery =
          normalizedQuery.isEmpty || _matchesQuery(book, normalizedQuery);

      return matchesCategory && matchesRating && matchesQuery;
    }).toList();

    _sortBooks(
      filtered,
      normalizedQuery: normalizedQuery,
      sortOption: sortOption,
    );

    return filtered;
  }

  void _sortBooks(
    List<BookModel> books, {
    required String normalizedQuery,
    required BookSortOption sortOption,
  }) {
    books.sort((a, b) {
      switch (sortOption) {
        case BookSortOption.priceLowToHigh:
          final byPrice = a.price.compareTo(b.price);
          if (byPrice != 0) {
            return byPrice;
          }
          return b.rating.compareTo(a.rating);
        case BookSortOption.rating:
          final byRating = b.rating.compareTo(a.rating);
          if (byRating != 0) {
            return byRating;
          }
          return a.title.compareTo(b.title);
        case BookSortOption.newest:
          final byNewest = _bookOrder(b).compareTo(_bookOrder(a));
          if (byNewest != 0) {
            return byNewest;
          }
          return a.title.compareTo(b.title);
        case BookSortOption.popularity:
          final byFeatured = (b.isFeatured ? 1 : 0).compareTo(
            a.isFeatured ? 1 : 0,
          );
          if (byFeatured != 0) {
            return byFeatured;
          }
          final byPopularityScore =
              _popularityScore(b).compareTo(_popularityScore(a));
          if (byPopularityScore != 0) {
            return byPopularityScore;
          }
          return a.title.compareTo(b.title);
        case BookSortOption.relevance:
          final scoreDifference =
              _matchScore(b, normalizedQuery) - _matchScore(a, normalizedQuery);
          if (scoreDifference != 0) {
            return scoreDifference;
          }
          final ratingDifference = b.rating.compareTo(a.rating);
          if (ratingDifference != 0) {
            return ratingDifference;
          }
          return a.title.compareTo(b.title);
      }
    });
  }

  bool _matchesQuery(BookModel book, String query) {
    return book.title.toLowerCase().contains(query) ||
        book.author.toLowerCase().contains(query) ||
        book.category.toLowerCase().contains(query) ||
        book.rating.toStringAsFixed(1).contains(query) ||
        book.rating.round().toString() == query;
  }

  int _matchScore(BookModel book, String query) {
    if (query.isEmpty) {
      return 0;
    }

    final title = book.title.toLowerCase();
    final author = book.author.toLowerCase();
    final category = book.category.toLowerCase();
    var score = 0;

    if (title == query) {
      score += 120;
    } else if (title.startsWith(query)) {
      score += 90;
    } else if (title.contains(query)) {
      score += 70;
    }

    if (author == query) {
      score += 100;
    } else if (author.startsWith(query)) {
      score += 80;
    } else if (author.contains(query)) {
      score += 60;
    }

    if (category == query) {
      score += 75;
    } else if (category.startsWith(query)) {
      score += 50;
    } else if (category.contains(query)) {
      score += 35;
    }

    if (book.rating.toStringAsFixed(1).startsWith(query) ||
        book.rating.round().toString() == query) {
      score += 25;
    }

    return score;
  }

  int _bookOrder(BookModel book) {
    return int.tryParse(book.id) ?? 0;
  }

  int _popularityScore(BookModel book) {
    final featuredBoost = book.isFeatured ? 100 : 0;
    final ratingBoost = (book.rating * 10).round();
    return featuredBoost + ratingBoost + book.stock;
  }

  List<String> _buildSuggestions(List<BookModel> books, String query) {
    final normalizedQuery = query.trim().toLowerCase();
    final candidates = <String>{
      ...books.map((book) => book.title),
      ...books.map((book) => book.author),
      ...books.map((book) => book.category),
      ...books.map((book) => '${book.rating.toStringAsFixed(1)}+ rated'),
    };

    final sorted = candidates.where((candidate) {
      if (normalizedQuery.isEmpty) {
        return true;
      }

      return candidate.toLowerCase().contains(normalizedQuery);
    }).toList()
      ..sort((a, b) {
        final aLower = a.toLowerCase();
        final bLower = b.toLowerCase();
        final aStarts = normalizedQuery.isNotEmpty && aLower.startsWith(normalizedQuery);
        final bStarts = normalizedQuery.isNotEmpty && bLower.startsWith(normalizedQuery);

        if (aStarts != bStarts) {
          return aStarts ? -1 : 1;
        }

        return aLower.compareTo(bLower);
      });

    return sorted.take(6).toList();
  }
}

final bookSearchProvider =
    AutoDisposeNotifierProvider<BookSearchNotifier, BookSearchState>(
  BookSearchNotifier.new,
);
