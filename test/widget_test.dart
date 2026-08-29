import 'package:flutter_test/flutter_test.dart';
import 'package:tes_buta_warna/main.dart';

void main() {
  testWidgets('App renders Home Screen and Test Options correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const TesButaWarnaApp());
    await tester.pumpAndSettle();

    // Verify title is rendered
    expect(find.text('Tes Buta Warna'), findsWidgets);
    expect(find.text('Tes Cepat (12 Pelat)'), findsOneWidget);
    expect(find.text('Tes Lengkap (24 Pelat)'), findsOneWidget);
  });
}
