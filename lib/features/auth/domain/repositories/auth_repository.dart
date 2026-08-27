import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> register({
    required String fullName,
    required String email,
    required String password,
    String? phone,
    String? nationality,
    String? passportNumber,
  });

  Future<User> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<bool> isLoggedIn();

  Future<User?> getCurrentUser();
}