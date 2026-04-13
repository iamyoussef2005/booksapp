import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/providers/app_settings_provider.dart';
import 'app/theme/app_theme.dart';
import 'features/auth/presentation/pages/auth_page.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/books/presentation/pages/books_home_page.dart';

void main() {
  runApp(const ProviderScope(child: BookShopApp()));
}

class BookShopApp extends ConsumerWidget {
  const BookShopApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider).valueOrNull ??
        const AppSettings();
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: 'Book Shop',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settings.themeMode,
      debugShowCheckedModeBanner: false,
      home: authState.when(
        data: (state) => state.isAuthenticated
            ? const BooksHomePage()
            : const AuthPage(),
        loading: () => const _AuthLoadingScreen(),
        error: (error, stackTrace) => const AuthPage(),
      ),
    );
  }
}

class _AuthLoadingScreen extends StatelessWidget {
  const _AuthLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
