import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/book_model.dart';

const _allCategory = 'All';

final searchQueryProvider = StateProvider<String>((ref) => '');

final selectedCategoryProvider = StateProvider<String>((ref) => _allCategory);

final booksProvider = Provider<List<BookModel>>((ref) {
  return const [
    BookModel(
      id: '1',
      title: 'The Midnight Library',
      author: 'Matt Haig',
      price: 18.99,
      rating: 4.8,
      description: 'A moving novel about regret, possibility, and second chances.',
      category: 'Fiction',
      imageUrl: 'assets/The Midnight Library.jpg',
      stock: 14,
      isFeatured: true,
    ),
    BookModel(
      id: '2',
      title: 'Atomic Habits',
      author: 'James Clear',
      price: 21.50,
      rating: 4.9,
      description: 'A practical guide to building good habits and breaking bad ones.',
      category: 'Self Help',
      imageUrl: 'assets/Atomic Habits.jpg',
      stock: 20,
      isFeatured: true,
    ),
    BookModel(
      id: '3',
      title: 'Dune',
      author: 'Frank Herbert',
      price: 16.25,
      rating: 4.7,
      description: 'A sweeping science fiction epic of politics, prophecy, and survival.',
      category: 'Science Fiction',
      imageUrl: 'assets/Dune.jpg',
      stock: 9,
      isFeatured: true,
    ),
    BookModel(
      id: '4',
      title: 'Before the Coffee Gets Cold',
      author: 'Toshikazu Kawaguchi',
      price: 14.99,
      rating: 4.6,
      description: 'A tender, time-bending story set inside a quiet cafe.',
      category: 'Fiction',
      imageUrl: 'assets/Before The Coffee Gets Cold.jpg',
      stock: 17,
      isFeatured: false,
    ),
    BookModel(
      id: '5',
      title: 'Deep Work',
      author: 'Cal Newport',
      price: 19.40,
      rating: 4.5,
      description: 'Strategies for focused success in a distracted world.',
      category: 'Business',
      imageUrl: 'assets/Deep Work.jpg',
      stock: 11,
      isFeatured: false,
    ),
    BookModel(
      id: '6',
      title: 'The Psychology of Money',
      author: 'Morgan Housel',
      price: 17.80,
      rating: 4.8,
      description: 'Timeless lessons on wealth, greed, and happiness.',
      category: 'Business',
      imageUrl: 'assets/The Psychology Of Money.jpg',
      stock: 18,
      isFeatured: false,
    ),
    BookModel(
      id: '7',
      title: 'Project Hail Mary',
      author: 'Andy Weir',
      price: 22.00,
      rating: 4.9,
      description: 'A science-driven survival story with heart and humor.',
      category: 'Science Fiction',
      imageUrl: 'assets/Project Hail Mary.jpg',
      stock: 8,
      isFeatured: false,
    ),
    BookModel(
      id: '8',
      title: 'The Song of Achilles',
      author: 'Madeline Miller',
      price: 15.75,
      rating: 4.7,
      description: 'A lyrical retelling of love and war in ancient Greece.',
      category: 'Romance',
      imageUrl: 'assets/The Song Of Achilles.jpg',
      stock: 13,
      isFeatured: false,
    ),
  ];
});

final categoriesProvider = Provider<List<String>>((ref) {
  final categories = ref
      .watch(booksProvider)
      .map((book) => book.category)
      .toSet()
      .toList()
    ..sort();

  return <String>[_allCategory, ...categories];
});

final featuredBooksProvider = Provider<List<BookModel>>((ref) {
  return ref.watch(booksProvider).where((book) => book.isFeatured).toList();
});

final filteredBooksProvider = Provider<List<BookModel>>((ref) {
  final books = ref.watch(booksProvider);
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final selectedCategory = ref.watch(selectedCategoryProvider);

  return books.where((book) {
    final matchesCategory =
        selectedCategory == _allCategory || book.category == selectedCategory;
    final matchesQuery =
        query.isEmpty ||
        book.title.toLowerCase().contains(query) ||
        book.author.toLowerCase().contains(query) ||
        book.category.toLowerCase().contains(query);

    return matchesCategory && matchesQuery;
  }).toList();
});
