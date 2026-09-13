import 'package:go_router/go_router.dart';

import 'app_shell.dart';
import '../../features/onboarding/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/welcome_screen.dart';
import '../../features/auth/presentation/screens/create_account_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/sync/presentation/screens/loading_screen.dart';
import '../../features/sync/presentation/screens/api_error_screen.dart';
import '../../features/sync/presentation/screens/session_expired_screen.dart';
import '../../features/sync/presentation/screens/submission_failure_screen.dart';
import '../../features/booking/presentation/screens/entry_details_screen.dart';
import '../../features/booking/presentation/screens/traveler_info_screen.dart';
import '../../features/booking/presentation/screens/visit_travel_details_screen.dart';
import '../../features/booking/presentation/screens/health_screening_screen.dart';
import '../../features/booking/presentation/screens/epidemiological_declaration_screen.dart';
import '../../features/booking/presentation/screens/booking_confirmed_screen.dart';
import '../../features/booking/presentation/screens/booking_history_screen.dart';
import '../../features/booking/presentation/screens/booking_details_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      // Splash
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

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
        builder: (context, state, child) => AppShell(child: child),
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
        path: '/booking',
        name: 'booking',
        builder: (context, state) => const EntryDetailsScreen(),
      ),
      GoRoute(
        path: '/booking/traveler',
        name: 'bookingTraveler',
        builder: (context, state) => const TravelerInfoScreen(),
      ),
      GoRoute(
        path: '/booking/visit',
        name: 'bookingVisit',
        builder: (context, state) => const VisitTravelDetailsScreen(),
      ),
      GoRoute(
        path: '/booking/health',
        name: 'bookingHealth',
        builder: (context, state) => const HealthScreeningScreen(),
      ),
      GoRoute(
        path: '/booking/review',
        name: 'bookingReview',
        builder: (context, state) => const EpidemiologicalDeclarationScreen(),
      ),
      GoRoute(
        path: '/booking/confirmed',
        name: 'bookingConfirmed',
        builder: (context, state) => const BookingConfirmedScreen(),
      ),
      GoRoute(
        path: '/bookings/:id',
        name: 'bookingDetails',
        builder: (context, state) => BookingDetailsScreen(
          bookingId: state.pathParameters['id']!,
        ),
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