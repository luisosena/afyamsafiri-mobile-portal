import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../booking/presentation/providers/booking_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../shared/widgets/molecules/offline_banner.dart';
import 'upcoming_booking_card.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().loadBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final bookingProvider = context.watch<BookingProvider>();
    final userName = authProvider.user?.fullName ?? 'Traveller';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.brandBlue,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Column(
        children: [
          // Top Header Bar with Coat of Arms
          const _TopHeaderBar(),

          // Scrollable Body Content
          Expanded(
            child: Container(
              color: AppColors.white,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.containerPadding,
                  vertical: AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const OfflineBanner(),
                    _GreetingHeader(userName: userName),
                    const SizedBox(height: 20),
                    _WelcomeBannerCard(
                      onTap: () => context.go('/booking'),
                    ),
                    if (bookingProvider.latestSubmittedBooking != null) ...[
                      const SizedBox(height: 20),
                      UpcomingBookingCard(
                        booking: bookingProvider.latestSubmittedBooking!,
                        onViewDetails: () => context.go(
                          '/bookings/${bookingProvider.latestSubmittedBooking!.id}',
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopHeaderBar extends StatelessWidget {
  const _TopHeaderBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.brandBlue,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/coat_of_arms.png',
                width: 36,
                height: 36,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 4),
              const Text(
                'AfyaMsafiri',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Traveler Health Surveillance',
                style: TextStyle(
                  color: AppColors.white.withValues(alpha: 0.9),
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader({required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    final displayName = userName.isNotEmpty && userName != 'Traveller'
        ? userName
        : 'Traveller';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello $displayName',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepSlate,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Welcome to travelers\' health surveillance system',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: const Text(
                'US',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepSlate,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: AppColors.lightBlueAccent,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.notifications,
                  color: AppColors.deepSlate,
                  size: 20,
                ),
                onPressed: () => context.go('/notifications'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WelcomeBannerCard extends StatelessWidget {
  const _WelcomeBannerCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.bannerBlue,
        borderRadius: BorderRadius.circular(24),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Decorative background bubble arcs
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white.withValues(alpha: 0.12),
                ),
              ),
            ),
            Positioned(
              left: -40,
              bottom: -40,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white.withValues(alpha: 0.08),
                ),
              ),
            ),

            // Card content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome to Tanzania',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        foregroundColor: AppColors.bannerBlue,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        alignment: Alignment.center,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(Icons.add, color: AppColors.bannerBlue, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'Create Arrival Booking',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.bannerBlue,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}