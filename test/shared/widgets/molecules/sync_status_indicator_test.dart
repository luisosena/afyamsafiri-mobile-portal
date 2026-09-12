import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:afyamsafiri/core/constants/app_colors.dart';
import 'package:afyamsafiri/shared/widgets/molecules/sync_status_indicator.dart';

void main() {
  Widget buildIndicator({
    bool synced = false,
    bool syncFailed = false,
    double size = 10,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SyncStatusIndicator(
          synced: synced,
          syncFailed: syncFailed,
          size: size,
        ),
      ),
    );
  }

  group('SyncStatusIndicator', () {
    testWidgets('shows green when synced', (tester) async {
      await tester.pumpWidget(buildIndicator(synced: true));

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AppColors.successGreen);
      expect(decoration.shape, BoxShape.circle);
    });

    testWidgets('shows yellow when not synced', (tester) async {
      await tester.pumpWidget(buildIndicator(synced: false));

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AppColors.warningYellow);
    });

    testWidgets('shows red when sync failed', (tester) async {
      await tester.pumpWidget(buildIndicator(syncFailed: true));

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AppColors.urgentRed);
    });

    testWidgets('syncFailed takes precedence over synced', (tester) async {
      await tester.pumpWidget(buildIndicator(synced: true, syncFailed: true));

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AppColors.urgentRed);
    });

    testWidgets('respects custom size', (tester) async {
      await tester.pumpWidget(buildIndicator(size: 20));

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.constraints!.maxWidth, 20);
      expect(container.constraints!.maxHeight, 20);
    });
  });
}
