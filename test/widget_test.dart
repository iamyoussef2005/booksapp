import 'package:flutter_test/flutter_test.dart';

import 'package:books/main.dart';

void main() {
  testWidgets('renders book shop placeholder', (WidgetTester tester) async {
    await tester.pumpWidget(const BookShopApp());

    expect(find.text('Book Shop app structure is ready.'), findsOneWidget);
  });
}
