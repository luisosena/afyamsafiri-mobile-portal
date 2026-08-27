import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/onboarding/presentation/screens/welcome_screen.dart';
import '../../features/auth/presentation/screens/create_account_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/booking/presentation/screens/arrival_booking_screen.dart';
import '../../features/booking/presentation/screens/booking_review_screen.dart';
import '../../features/booking/presentation/screens/booking_confirmed_screen.dart';
import '../../features/booking/presentation/screens/booking_history_screen.dart';
import '../../features/booking/presentation/screens/booking_details_screen.dart';
import '../../features/screening/presentation/screens/travel_history_screen.dart';
import '../../features/screening/presentation/screens/symptoms_screen.dart';
import '../../features/screening/presentation/screens/vaccination_screen.dart';
import '../../features/screening/presentation/screens/additional_health_screen.dart';
import '../../features/screening/presentation/screens/screening_review_screen.dart';
import '../../features/confirmation/presentation/screens/confirmation_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/sync/presentation/screens/loading_screen.dart';
import '../../features/sync/presentation/screens/api_error_screen.dart';
import '../../features/sync/presentation/screens/session_expired_screen.dart';
import '../../features/sync/presentation/screens/submission_failure_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/welcome',
    routes: [
      // Onboarding
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),

      // Auth
      GoRoute(
        path: '/create-account',
        name: 'createAccount',
        builder: (context, state) => const CreateAccountScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Main shell with bottom nav
      ShellRoute(
        builder: (context, state, child) => child,
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/bookings',
            name: 'bookings',
            builder: (context, state) => const BookingHistoryScreen(),
          ),
          GoRoute(
            path: '/notifications',
            name: 'notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // Booking flow
      GoRoute(
        path: '/booking/new',
        name: 'newBooking',
        builder: (context, state) => const ArrivalBookingScreen(),
      ),
      GoRoute(
        path: '/booking/review',
        name: 'bookingReview',
        builder: (context, state) => const BookingReviewScreen(),
      ),
      GoRoute(
        path: '/booking/confirmed',
        name: 'bookingConfirmed',
        builder: (context, state) => const BookingConfirmedScreen(),
      ),
      GoRoute(
        path: '/booking/:id',
        name: 'bookingDetails',
        builder: (context, state) => BookingDetailsScreen(
          bookingId: state.pathParameters['id']!,
        ),
      ),

      // Screening flow
      GoRoute(
        path: '/screening/travel-history',
        name: 'screeningTravelHistory',
        builder: (context, state) => const TravelHistoryScreen(),
      ),
      GoRoute(
        path: '/screening/symptoms',
        name: 'screeningSymptoms',
        builder: (context, state) => const SymptomsScreen(),
      ),
      GoRoute(
        path: '/screening/vaccination',
        name: 'screeningVaccination',
        builder: (context, state) => const VaccinationScreen(),
      ),
      GoRoute(
        path: '/screening/additional',
        name: 'screeningAdditional',
        builder: (context, state) => const AdditionalHealthScreen(),
      ),
      GoRoute(
        path: '/screening/review',
        name: 'screeningReview',
        builder: (context, state) => const ScreeningReviewScreen(),
      ),

      // Confirmation
      GoRoute(
        path: '/confirmation',
        name: 'confirmation',
        builder: (context, state) => const ConfirmationScreen(),
      ),

      // Sync / Error states
      GoRoute(
        path: '/loading',
        name: 'loading',
        builder: (context, state) => const LoadingScreen(),
      ),
      GoRoute(
        path: '/error/api',
        name: 'apiError',
        builder: (context, state) => const ApiErrorScreen(),
      ),
      GoRoute(
        path: '/error/session-expired',
        name: 'sessionExpired',
        builder: (context, state) => const SessionExpiredScreen(),
      ),
      GoRoute(
        path: '/error/submission-failure',
        name: 'submissionFailure',
        builder: (context, state) => const SubmissionFailureScreen(),
      ),
    ],
  );
}
