import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:afyamsafiri/core/network/connectivity_service.dart';
import 'package:afyamsafiri/features/auth/domain/entities/user.dart';
import 'package:afyamsafiri/features/auth/presentation/providers/auth_provider.dart';
import 'package:afyamsafiri/features/booking/domain/entities/booking.dart';
import 'package:afyamsafiri/features/booking/presentation/providers/booking_provider.dart';
import 'package:afyamsafiri/features/home/presentation/widgets/home_dashboard.dart';

class MockAuthProvider extends Mock implements AuthProvider {}
class MockBookingProvider extends Mock implements BookingProvider {}
class MockConnectivityService extends Mock implements ConnectivityService {
  @override
  bool get isOnline => true;
}

void main() {
  late MockAuthProvider mockAuthProvider;
  late MockBookingProvider mockBookingProvider;
  late MockConnectivityService mockConnectivityService;

  const testUser = User(
    id: 'u1',
    fullName: 'John Doe',
    email: 'john@example.com',
  );

  final testBooking = Booking(
    id: 'bk-1',
    referenceCode: 'TZ-2026-001',
    status: BookingStatus.submitted,
    passportNumber: 'AB1234567',
    portOfEntry: 'Julius Nyerere International Airport',
    arrivalDate: DateTime(2026, 9, 15),
    firstName: 'John',
    surname: 'Doe',
    gender: 'Male',
    nationality: 'American',
    vesselName: 'KQ480',
    purposeOfVisit: 'Tourism',
    localPhone: '+255712345678',
    email: 'john@example.com',
    journeyStartCountry: 'Kenya',
    symptoms: Booking.createDefaultSymptoms(),
    createdAt: DateTime(2026, 9, 1),
  );

  setUp(() {
    mockAuthProvider = MockAuthProvider();
    mockBookingProvider = MockBookingProvider();
    mockConnectivityService = MockConnectivityService();

    when(() => mockAuthProvider.user).thenReturn(testUser);
    when(() => mockBookingProvider.latestSubmittedBooking).thenReturn(null);
    when(() => mockBookingProvider.bookings).thenReturn([]);
    when(() => mockBookingProvider.loadBookings()).thenAnswer((_) async {});
  });

  Widget buildHomeDashboard() {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<ConnectivityService>.value(value: mockConnectivityService),
          ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
          ChangeNotifierProvider<BookingProvider>.value(value: mockBookingProvider),
        ],
        child: const Scaffold(body: HomeDashboard()),
      ),
    );
  }

  group('HomeDashboard', () {
    testWidgets('renders greeting with user name', (tester) async {
      await tester.pumpWidget(buildHomeDashboard());
      await tester.pumpAndSettle();

      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('renders greeting with fallback name when user is null', (tester) async {
      when(() => mockAuthProvider.user).thenReturn(null);

      await tester.pumpWidget(buildHomeDashboard());
      await tester.pumpAndSettle();

      expect(find.text('Traveller'), findsOneWidget);
    });

    testWidgets('renders Plan Your Trip card', (tester) async {
      await tester.pumpWidget(buildHomeDashboard());
      await tester.pumpAndSettle();

      expect(find.text('Plan Your Trip'), findsOneWidget);
    });

    testWidgets('renders quick action cards', (tester) async {
      await tester.pumpWidget(buildHomeDashboard());
      await tester.pumpAndSettle();

      expect(find.text('My QR Pass'), findsOneWidget);
      expect(find.text('History'), findsOneWidget);
    });

    testWidgets('renders notification bell', (tester) async {
      await tester.pumpWidget(buildHomeDashboard());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    });

    testWidgets('shows upcoming booking card when booking exists', (tester) async {
      when(() => mockBookingProvider.latestSubmittedBooking).thenReturn(testBooking);

      await tester.pumpWidget(buildHomeDashboard());
      await tester.pumpAndSettle();

      expect(find.text('TZ-2026-001'), findsOneWidget);
      expect(find.text('View Booking Details'), findsOneWidget);
    });

    testWidgets('does not show upcoming booking card when no bookings', (tester) async {
      await tester.pumpWidget(buildHomeDashboard());
      await tester.pumpAndSettle();

      expect(find.text('View Booking Details'), findsNothing);
    });

    testWidgets('calls loadBookings on init', (tester) async {
      await tester.pumpWidget(buildHomeDashboard());
      await tester.pumpAndSettle();

      verify(() => mockBookingProvider.loadBookings()).called(1);
    });
  });
}
