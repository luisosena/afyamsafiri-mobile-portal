import '../models/registration_request.dart';
import '../models/auth_response.dart';

class AuthMockDataSource {
  String? _currentUserId;
  String? _currentToken;
  bool _isLoggedIn = false;

  Future<AuthResponse> register(RegistrationRequest request) async {
    await Future.delayed(const Duration(seconds: 1));

    _currentUserId = 'mock-user-001';
    _currentToken = 'mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}';
    _isLoggedIn = true;

    return AuthResponse(
      userId: _currentUserId!,
      token: _currentToken!,
      refreshToken: 'mock-refresh-token',
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
    );
  }

  Future<AuthResponse> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty || password.isEmpty) {
      throw Exception('Invalid credentials');
    }

    _currentUserId = 'mock-user-001';
    _currentToken = 'mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}';
    _isLoggedIn = true;

    return AuthResponse(
      userId: _currentUserId!,
      token: _currentToken!,
      refreshToken: 'mock-refresh-token',
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
    );
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUserId = null;
    _currentToken = null;
    _isLoggedIn = false;
  }

  Future<bool> isLoggedIn() async {
    return _isLoggedIn;
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    if (!_isLoggedIn) return null;

    return {
      'id': 'mock-user-001',
      'fullName': 'John Doe',
      'email': 'john.doe@example.com',
      'phone': '+255712345678',
      'nationality': 'Tanzania',
      'passportNumber': 'AB1234567',
    };
  }
}