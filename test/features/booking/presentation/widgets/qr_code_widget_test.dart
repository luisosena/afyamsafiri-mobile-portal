import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:afyamsafiri/features/booking/presentation/widgets/qr_code_widget.dart';

void main() {
  group('QrCodeWidget', () {
    Widget buildWidget({
      String bookingID = 'bk-001',
      String arrivalDate = '2026-09-15',
      String portOfEntry = 'DAR',
      double size = 140,
      bool showLabel = true,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: QrCodeWidget(
            bookingID: bookingID,
            arrivalDate: arrivalDate,
            portOfEntry: portOfEntry,
            size: size,
            showLabel: showLabel,
          ),
        ),
      );
    }

    testWidgets('renders QrImageView', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.byType(QrImageView), findsOneWidget);
    });

    testWidgets('renders "Scan to verify" label by default', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Scan to verify'), findsOneWidget);
    });

    testWidgets('hides label when showLabel is false', (tester) async {
      await tester.pumpWidget(buildWidget(showLabel: false));

      expect(find.text('Scan to verify'), findsNothing);
    });

    testWidgets('renders QrImageView with auto version', (tester) async {
      await tester.pumpWidget(buildWidget());

      final qrImage = tester.widget<QrImageView>(find.byType(QrImageView));
      expect(qrImage.version, QrVersions.auto);
    });

    testWidgets('renders container widget', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.byType(Container), findsWidgets);
    });
  });
}
