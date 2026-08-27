class Profile {
  const Profile({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.nationality,
    this.passportNumber,
    this.profileImageUrl,
  });

  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final String? nationality;
  final String? passportNumber;
  final String? profileImageUrl;

  Profile copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? nationality,
    String? passportNumber,
    String? profileImageUrl,
  }) {
    return Profile(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      nationality: nationality ?? this.nationality,
      passportNumber: passportNumber ?? this.passportNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}