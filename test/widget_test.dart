import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tes_buta_warna/screens/home_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'app_has_seen_tour': true,
    });
  });

  testWidgets('App renders Home Screen and Test Options correctly', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );
    // Pump microtasks and frames until _loadData completes
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Tes Buta Warna Lengkap'), findsWidgets);
    expect(find.text('Tes Cepat (12 Pelat)'), findsOneWidget);
    expect(find.text('Tes Lengkap (24 Pelat)'), findsOneWidget);
  });
}
