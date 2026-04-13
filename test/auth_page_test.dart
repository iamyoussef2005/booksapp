import 'package:books/features/auth/presentation/pages/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('auth page renders sign in mode', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: AuthPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Sign In'), findsWidgets);
    expect(find.text('Enter Book Shop'), findsOneWidget);
  });
}
