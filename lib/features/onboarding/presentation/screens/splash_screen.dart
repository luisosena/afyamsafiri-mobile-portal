import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_shell.dart';
import '../../../home/presentation/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1050),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: const Cubic(0.2, 0.0, 0.0, 1.0), // Luxurious smooth cubic curve
    );

    // Pause briefly on splash screen, then animate coat of arms slide up & shrink
    Timer(const Duration(milliseconds: 1200), () {
      if (mounted) {
        _controller.forward().then((_) {
          if (mounted) {
            context.go('/home');
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final topPadding = mediaQuery.padding.top;
    final headerHeightEnd = topPadding + 96.0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final t = _animation.value;

            // Interpolated dimensions and positions
            final currentBgHeight = _lerp(screenHeight, headerHeightEnd, t);
            final currentImageSize = _lerp(76.0, 36.0, t);
            final currentSpacing1 = _lerp(20.0, 4.0, t);
            final currentTitleSize = _lerp(30.0, 16.0, t);
            final currentSpacing2 = _lerp(6.0, 2.0, t);
            final currentSubtitleSize = _lerp(15.0, 11.0, t);

            // Splash center content height at t=0 vs header top at t=1
            final splashContentHeight = 76.0 + 20.0 + 36.0 + 6.0 + 18.0;
            final initialTop = (screenHeight - splashContentHeight) / 2;
            final targetTop = topPadding + 8.0;
            final currentTop = _lerp(initialTop, targetTop, t);

            return Stack(
              children: [
                // Layer 1: Complete AppShell + HomeScreen (fading in and sliding up seamlessly)
                Positioned.fill(
                  child: Opacity(
                    opacity: t,
                    child: Transform.translate(
                      offset: Offset(0, 24 * (1 - t)),
                      child: const AppShell(
                        child: HomeScreen(),
                      ),
                    ),
                  ),
                ),

                // Layer 2: Animated Blue Background + Sliding & Shrinking Coat of Arms
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
            );
          },
        ),
      ),
    );
  }
}