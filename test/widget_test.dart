import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latihan_riverpod/main.dart';

void main() {
  testWidgets('Kantin smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: KantinPage(),
      ),
    );

    expect(find.text('Total: Rp 0'), findsNothing);
  });
}
