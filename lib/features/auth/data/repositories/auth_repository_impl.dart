import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../datasources/auth_mock_datasource.dart';
import '../models/registration_request.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.remoteDataSource,
  });

  final AuthMockDataSource remoteDataSource;

  @override
  Future<User> register({
    required String fullName,
    required String email,
    required String password,
    String? phone,
    String? nationality,
    String? passportNumber,
  }) async {
    final request = RegistrationRequest(
      fullName: fullName,
      email: email,
      password: password,
      phone: phone,
      nationality: nationality,
      passportNumber: passportNumber,
    );

    final response = await remoteDataSource.register(request);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', response.token);
    await prefs.setString('user_id', response.userId);

    return User(
      id: response.userId,
      fullName: fullName,
      email: email,
      phone: phone,
      nationality: nationality,
      passportNumber: passportNumber,
    );
  }

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    final response = await remoteDataSource.login(email, password);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', response.token);
    await prefs.setString('user_id', response.userId);

    final userData = await remoteDataSource.getCurrentUser();
    if (userData == null) throw Exception('Login failed');

    return User(
      id: userData['id'] as String,
      fullName: userData['fullName'] as String,
      email: userData['email'] as String,
      phone: userData['phone'] as String?,
      nationality: userData['nationality'] as String?,
      passportNumber: userData['passportNumber'] as String?,
    );
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
  }

  @override
  Future<bool> isLoggedIn() async {
    return remoteDataSource.isLoggedIn();
  }

  @override
  Future<User?> getCurrentUser() async {
    final userData = await remoteDataSource.getCurrentUser();
    if (userData == null) return null;

    return User(
      id: userData['id'] as String,
      fullName: userData['fullName'] as String,
      email: userData['email'] as String,
      phone: userData['phone'] as String?,
      nationality: userData['nationality'] as String?,
      passportNumber: userData['passportNumber'] as String?,
    );
  }
}