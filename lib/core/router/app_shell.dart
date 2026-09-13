import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../../../shared/widgets/molecules/app_bottom_nav_bar.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  static bool hasPlayedSplash = false;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showSplashOverlay = false;

  @override
  void initState() {
    super.initState();

    if (!AppShell.hasPlayedSplash) {
      AppShell.hasPlayedSplash = true;
      _showSplashOverlay = true;

      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1600),
      );

      _animation = CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      );

      // Display splash screen for 2200ms, then run smooth 1600ms transition
      Timer(const Duration(milliseconds: 2200), () {
        if (mounted) {
          _controller.forward().then((_) {
            if (mounted) {
              setState(() {
                _showSplashOverlay = false;
              });
            }
          });
        }
      });
    }
  }

  @override
  void dispose() {
    if (_showSplashOverlay) {
      _controller.dispose();
    }
    super.dispose();
  }

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/bookings')) return 1;
    if (location.startsWith('/notifications')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/bookings');
        break;
      case 2:
        context.go('/notifications');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final topPadding = mediaQuery.padding.top;
    final headerHeightEnd = topPadding + 95.0;

    return Stack(
      children: [
        // Main App Shell with body and bottom nav bar
        Scaffold(
          body: widget.child,
          bottomNavigationBar: AppBottomNavBar(
            currentIndex: _currentIndex(context),
            onTap: (index) => _onTap(context, index),
          ),
        ),

        // Seamless Splash Overlay (plays once on app startup)
        if (_showSplashOverlay)
          Positioned.fill(
            child: AbsorbPointer(
              absorbing: true,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  final t = _animation.value;

                  final currentBgHeight = _lerp(screenHeight, headerHeightEnd, t);
                  final currentImageSize = _lerp(76.0, 36.0, t);
                  final currentSpacing1 = _lerp(20.0, 4.0, t);
                  final currentTitleSize = _lerp(30.0, 16.0, t);
                  final currentSpacing2 = _lerp(6.0, 2.0, t);
                  final currentSubtitleSize = _lerp(15.0, 11.0, t);

                  final splashContentHeight = 76.0 + 20.0 + 36.0 + 6.0 + 18.0;
                  final initialTop = (screenHeight - splashContentHeight) / 2;
                  final targetTop = topPadding + 8.0;
                  final currentTop = _lerp(initialTop, targetTop, t);

                  return AnnotatedRegion<SystemUiOverlayStyle>(
                    value: const SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: Brightness.light,
                      statusBarBrightness: Brightness.dark,
                    ),
                    child: Material(
                      type: MaterialType.transparency,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            height: currentBgHeight,
                            child: Container(
                              color: AppColors.brandBlue,
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: currentTop,
                                    left: 0,
                                    right: 0,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          'assets/images/coat_of_arms.png',
                                          width: currentImageSize,
                                          height: currentImageSize,
                                          fit: BoxFit.contain,
                                        ),
                                        SizedBox(height: currentSpacing1),
                                        Text(
                                          'AfyaMsafiri',
                                          style: TextStyle(
                                            color: AppColors.white,
                                            fontSize: currentTitleSize,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: -0.5 * (1 - t),
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                        SizedBox(height: currentSpacing2),
                                        Text(
                                          'Traveler Health Surveillance',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: AppColors.white.withValues(
                                              alpha: _lerp(0.95, 0.9, t),
                                            ),
                                            fontSize: currentSubtitleSize,
                                            fontWeight: FontWeight.w400,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );

                },
              ),
            ),
          ),
      ],
    );
  }
}