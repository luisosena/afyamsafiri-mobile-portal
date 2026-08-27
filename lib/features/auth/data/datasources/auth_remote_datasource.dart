import '../models/registration_request.dart';
import '../models/auth_response.dart';

class AuthRemoteDataSource {
  Future<AuthResponse> register(RegistrationRequest request) async {
    throw UnimplementedError('Remote API not yet available');
  }

  Future<AuthResponse> login(String email, String password) async {
    throw UnimplementedError('Remote API not yet available');
  }

  Future<void> logout() async {
    throw UnimplementedError('Remote API not yet available');
  }

  Future<bool> isLoggedIn() async {
    throw UnimplementedError('Remote API not yet available');
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    throw UnimplementedError('Remote API not yet available');
  }
}