import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/datasources/auth_mock_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/booking/data/datasources/booking_mock_datasource.dart';
import 'features/booking/data/repositories/booking_repository_impl.dart';
import 'features/booking/presentation/providers/booking_provider.dart';

class AfyaMsafiriApp extends StatelessWidget {
  const AfyaMsafiriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            authRepository: AuthRepositoryImpl(
              remoteDataSource: AuthMockDataSource(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => BookingProvider(
            bookingRepository: BookingRepositoryImpl(
              remoteDataSource: BookingMockDataSource(),
            ),
          ),
        ),
      ],
      child: MaterialApp.router(
        title: 'AfyaMsafiri',
        theme: AppTheme.light,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
