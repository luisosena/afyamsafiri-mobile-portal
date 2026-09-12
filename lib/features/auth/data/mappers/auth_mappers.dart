import 'package:d2_touch/modules/auth/entities/user.entity.dart';
import '../models/auth_response.dart';

AuthResponse mapD2UserToAuthResponse(User user) {
  return AuthResponse(
    userId: user.id ?? '',
    token: user.token ?? '',
    refreshToken: user.refreshToken,
    expiresAt: user.tokenExpiresAt != null
        ? DateTime.tryParse(user.tokenExpiresAt!)
        : null,
  );
}

Map<String, dynamic> mapD2UserToCurrentUser(User user) {
  return {
    'id': user.id,
    'fullName': '${user.firstName} ${user.surname ?? ''}'.trim(),
    'email': user.username,
    'phone': user.phoneNumber,
    'gender': user.gender,
  };
}