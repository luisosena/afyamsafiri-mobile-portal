import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:afyamsafiri/core/network/connectivity_service.dart';
import 'package:afyamsafiri/shared/widgets/molecules/offline_banner.dart';

class MockConnectivityService extends Mock implements ConnectivityService {}

void main() {
  late MockConnectivityService mockConnectivity;

  setUp(() {
    mockConnectivity = MockConnectivityService();
  });

  Widget buildBanner() {
    return MaterialApp(
      home: Scaffold(
        body: ChangeNotifierProvider<ConnectivityService>.value(
          value: mockConnectivity,
          child: const OfflineBanner(),
        ),
      ),
    );
  }

  group('OfflineBanner', () {
    testWidgets('shows offline message when offline', (tester) async {
      when(() => mockConnectivity.isOnline).thenReturn(false);

      await tester.pumpWidget(buildBanner());

      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
      expect(
        find.text('You are offline. Changes will sync when connected.'),
        findsOneWidget,
      );
    });

    testWidgets('hides when online', (tester) async {
      when(() => mockConnectivity.isOnline).thenReturn(true);

      await tester.pumpWidget(buildBanner());

      expect(find.byIcon(Icons.wifi_off), findsNothing);
      expect(
        find.text('You are offline. Changes will sync when connected.'),
        findsNothing,
      );
    });
  });
}
