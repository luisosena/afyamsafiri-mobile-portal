class AuthResponse {
  const AuthResponse({
    required this.userId,
    required this.token,
    this.refreshToken,
    this.expiresAt,
  });

  final String userId;
  final String token;
  final String? refreshToken;
  final DateTime? expiresAt;

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      userId: json['userId'] as String,
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String?,
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'token': token,
        if (refreshToken != null) 'refreshToken': refreshToken,
        if (expiresAt != null) 'expiresAt': expiresAt!.toIso8601String(),
      };
}