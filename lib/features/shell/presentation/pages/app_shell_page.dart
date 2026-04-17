import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/widgets/app_icon.dart';
import '../../../../core/widgets/app_user_avatar.dart';
import '../../../account/presentation/pages/account_page.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../books/presentation/pages/books_home_page.dart';
import '../../../books/presentation/pages/cart_page.dart';
import '../../../books/presentation/providers/cart_providers.dart';

class AppShellPage extends ConsumerStatefulWidget {
  const AppShellPage({super.key});

  @override
  ConsumerState<AppShellPage> createState() => _AppShellPageState();
}

class _AppShellPageState extends ConsumerState<AppShellPage> {
  int _currentIndex = 0;

  void _selectTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = ref.watch(cartItemCountProvider);
    final auth = ref.watch(authProvider).valueOrNull;

    final pages = <Widget>[
      BooksHomePage(
        onOpenCart: () => _selectTab(1),
        onOpenAccount: () => _selectTab(2),
      ),
      const CartPage(),
      const AccountPage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _selectTab,
        destinations: [
          const NavigationDestination(
            icon: AppIcon(HugeIcons.strokeRoundedBookOpen01),
            selectedIcon: AppIcon(HugeIcons.strokeRoundedBookOpen01),
            label: 'Books',
          ),
          NavigationDestination(
            icon: Badge.count(
              count: cartCount,
              isLabelVisible: cartCount > 0,
              child: const AppIcon(HugeIcons.strokeRoundedShoppingBag02),
            ),
            selectedIcon: Badge.count(
              count: cartCount,
              isLabelVisible: cartCount > 0,
              child: const AppIcon(HugeIcons.strokeRoundedShoppingBag02),
            ),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: AppUserAvatar(
              fullName: auth?.user?.fullName,
              email: auth?.user?.email,
              radius: 12,
            ),
            selectedIcon: AppUserAvatar(
              fullName: auth?.user?.fullName,
              email: auth?.user?.email,
              radius: 12,
            ),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
