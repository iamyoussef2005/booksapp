import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/book_model.dart';

class CartItem {
  const CartItem({
    required this.book,
    required this.quantity,
  });

  final BookModel book;
  final int quantity;

  double get totalPrice => book.price * quantity;

  CartItem copyWith({
    BookModel? book,
    int? quantity,
  }) {
    return CartItem(
      book: book ?? this.book,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() => const [];

  void addItem(BookModel book, {int quantity = 1}) {
    final existingIndex = state.indexWhere((item) => item.book.id == book.id);

    if (existingIndex == -1) {
      final safeQuantity = quantity.clamp(1, book.stock);
      state = [...state, CartItem(book: book, quantity: safeQuantity)];
      return;
    }

    final updated = [...state];
    final current = updated[existingIndex];
    final nextQuantity = current.quantity + quantity;
    updated[existingIndex] = current.copyWith(
      quantity: nextQuantity > book.stock ? book.stock : nextQuantity,
    );
    state = updated;
  }

  void removeItem(String bookId) {
    state = state.where((item) => item.book.id != bookId).toList();
  }

  void updateQuantity(String bookId, int quantity) {
    if (quantity <= 0) {
      removeItem(bookId);
      return;
    }

    state = [
      for (final item in state)
        if (item.book.id == bookId)
          item.copyWith(
            quantity: quantity.clamp(1, item.book.stock),
          )
        else
          item,
    ];
  }

  void clearCart() {
    state = const [];
  }

  double computeTotal() {
    return state.fold<double>(
      0,
      (total, item) => total + item.totalPrice,
    );
  }
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(
  CartNotifier.new,
);

final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).fold<int>(
        0,
        (total, item) => total + item.quantity,
      );
});

final cartTotalProvider = Provider<double>((ref) {
  ref.watch(cartProvider);
  return ref.read(cartProvider.notifier).computeTotal();
});
