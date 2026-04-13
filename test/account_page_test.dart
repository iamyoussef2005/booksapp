import 'package:books/features/account/presentation/pages/account_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('account page renders without crashing', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: AccountPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Profile & Settings'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);
  });
}
