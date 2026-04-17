import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/providers/app_settings_provider.dart';
import 'app/theme/app_theme.dart';
import 'core/widgets/app_state_view.dart';
import 'features/auth/presentation/pages/auth_page.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/shell/presentation/pages/app_shell_page.dart';
import 'features/splash/presentation/pages/splash_page.dart';

void main() {
  runApp(const ProviderScope(child: BookShopApp()));
}

class BookShopApp extends ConsumerStatefulWidget {
  const BookShopApp({super.key});

  @override
  ConsumerState<BookShopApp> createState() => _BookShopAppState();
}

class _BookShopAppState extends ConsumerState<BookShopApp> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(seconds: 5), () {
      if (!mounted) {
        return;
      }

      setState(() => _showSplash = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings =
        ref.watch(appSettingsProvider).valueOrNull ?? const AppSettings();
    final authState = ref.watch(authProvider);
    final home = _showSplash
        ? const SplashPage()
        : authState.when(
            data: (state) => state.isAuthenticated
                ? const AppShellPage()
                : const AuthPage(),
            loading: () => const _AuthLoadingScreen(),
            error: (error, stackTrace) => _AuthErrorScreen(
              onRetry: () => ref.invalidate(authProvider),
            ),
          );

    return MaterialApp(
      title: 'Book Shop',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settings.themeMode,
      debugShowCheckedModeBanner: false,
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: KeyedSubtree(
          key: ValueKey<String>(
            '${_showSplash}_${authState.valueOrNull?.isAuthenticated ?? false}',
          ),
          child: home,
        ),
      ),
    );
  }
}

class _AuthLoadingScreen extends StatelessWidget {
  const _AuthLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AppLoadingView(message: 'Preparing your bookstore...'),
    );
  }
}

class _AuthErrorScreen extends StatelessWidget {
  const _AuthErrorScreen({
    required this.onRetry,
  });

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppErrorState(
        title: 'We could not open the app',
        message: 'Something went wrong while restoring your session.',
        onRetry: onRetry,
      ),
    );
  }
}
