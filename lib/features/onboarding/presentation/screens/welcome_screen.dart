import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'widgets/welcome_hero.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: WelcomeHero(),
        ),
      ),
    );
  }
}