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
import 'features/screening/data/datasources/screening_mock_datasource.dart';
import 'features/screening/data/repositories/screening_repository_impl.dart';
import 'features/screening/presentation/providers/screening_provider.dart';
import 'features/notifications/data/datasources/notification_mock_datasource.dart';
import 'features/notifications/data/repositories/notification_repository_impl.dart';
import 'features/notifications/presentation/providers/notification_provider.dart';
import 'features/profile/data/datasources/profile_mock_datasource.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/presentation/providers/profile_provider.dart';

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
        ChangeNotifierProvider(
          create: (_) => ScreeningProvider(
            screeningRepository: ScreeningRepositoryImpl(
              remoteDataSource: ScreeningMockDataSource(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationProvider(
            notificationRepository: NotificationRepositoryImpl(
              remoteDataSource: NotificationMockDataSource(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(
            profileRepository: ProfileRepositoryImpl(
              remoteDataSource: ProfileMockDataSource(),
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
