import '../models/auth_response.dart';
import '../models/registration_request.dart';

abstract class AuthDataSource {
  Future<AuthResponse> register(RegistrationRequest request);
  Future<AuthResponse> login(String email, String password);
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<Map<String, dynamic>?> getCurrentUser();
}
