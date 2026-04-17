import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../books/data/models/book_model.dart';
import '../../../books/presentation/providers/books_home_providers.dart';
import '../../../books/presentation/providers/cart_providers.dart';

class SavedAddress {
  const SavedAddress({
    required this.id,
    required this.label,
    required this.fullName,
    required this.phoneNumber,
    required this.addressLine,
    required this.city,
    required this.isDefault,
  });

  final String id;
  final String label;
  final String fullName;
  final String phoneNumber;
  final String addressLine;
  final String city;
  final bool isDefault;
}

class OrderHistoryItem {
  const OrderHistoryItem({
    required this.id,
    required this.dateLabel,
    required this.status,
    required this.total,
    required this.itemsCount,
    required this.books,
  });

  final String id;
  final String dateLabel;
  final String status;
  final double total;
  final int itemsCount;
  final List<BookModel> books;
}

class PaymentMethod {
  const PaymentMethod({
    required this.id,
    required this.label,
    required this.subtitle,
    required this.isDefault,
  });

  final String id;
  final String label;
  final String subtitle;
  final bool isDefault;
}

final _defaultWishlistIdsProvider = Provider<Set<String>>((ref) {
  final books = ref.watch(booksProvider);
  return books
      .where((book) => book.rating >= 4.7)
      .take(4)
      .map((book) => book.id)
      .toSet();
});

class WishlistNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {...ref.watch(_defaultWishlistIdsProvider)};

  void toggle(String bookId) {
    if (state.contains(bookId)) {
      state = {...state}..remove(bookId);
      return;
    }

    state = {...state, bookId};
  }
}

final wishlistIdsProvider = NotifierProvider<WishlistNotifier, Set<String>>(
  WishlistNotifier.new,
);

final wishlistProvider = Provider<List<BookModel>>((ref) {
  final books = ref.watch(booksProvider);
  final wishlistIds = ref.watch(wishlistIdsProvider);

  return books.where((book) => wishlistIds.contains(book.id)).toList();
});

final isInWishlistProvider = Provider.family<bool, String>((ref, bookId) {
  return ref.watch(wishlistIdsProvider).contains(bookId);
});

final savedAddressesProvider = Provider<List<SavedAddress>>((ref) {
  return const [
    SavedAddress(
      id: 'home',
      label: 'Home',
      fullName: 'Aseel T.',
      phoneNumber: '+963 944 000 000',
      addressLine: 'Al Hamra Street, Building 18, Apartment 4',
      city: 'Damascus',
      isDefault: true,
    ),
    SavedAddress(
      id: 'office',
      label: 'Office',
      fullName: 'Aseel T.',
      phoneNumber: '+963 944 000 111',
      addressLine: 'Abu Rummaneh, Floor 3, Desk 12',
      city: 'Damascus',
      isDefault: false,
    ),
  ];
});

final paymentMethodsProvider = Provider<List<PaymentMethod>>((ref) {
  return const [
    PaymentMethod(
      id: 'visa',
      label: 'Visa',
      subtitle: '**** 2401',
      isDefault: true,
    ),
    PaymentMethod(
      id: 'cash',
      label: 'Cash on Delivery',
      subtitle: 'Pay when your books arrive',
      isDefault: false,
    ),
  ];
});

class OrderHistoryNotifier extends Notifier<List<OrderHistoryItem>> {
  @override
  List<OrderHistoryItem> build() {
    final books = ref.watch(booksProvider);
    final featured = books.take(2).toList();
    final recent = books.skip(2).take(3).toList();
    final archive = books.skip(5).take(2).toList();

    return [
      OrderHistoryItem(
        id: '#BS-1042',
        dateLabel: 'April 10, 2026',
        status: 'Delivered',
        total: 40.49,
        itemsCount: featured.length,
        books: featured,
      ),
      OrderHistoryItem(
        id: '#BS-1031',
        dateLabel: 'March 27, 2026',
        status: 'Shipped',
        total: 56.95,
        itemsCount: recent.length,
        books: recent,
      ),
      OrderHistoryItem(
        id: '#BS-0994',
        dateLabel: 'February 12, 2026',
        status: 'Delivered',
        total: 31.80,
        itemsCount: archive.length,
        books: archive,
      ),
    ];
  }

  OrderHistoryItem placeOrder({
    required List<CartItem> cartItems,
    required double total,
  }) {
    final now = DateTime.now();
    final order = OrderHistoryItem(
      id: '#BS-${1000 + state.length + 1}',
      dateLabel: _formatDate(now),
      status: 'Confirmed',
      total: total,
      itemsCount: cartItems.fold<int>(
        0,
        (count, item) => count + item.quantity,
      ),
      books: [
        for (final item in cartItems) item.book,
      ],
    );
    state = [order, ...state];
    return order;
  }

  String _formatDate(DateTime date) {
    const months = <String>[
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

final orderHistoryProvider =
    NotifierProvider<OrderHistoryNotifier, List<OrderHistoryItem>>(
  OrderHistoryNotifier.new,
);
