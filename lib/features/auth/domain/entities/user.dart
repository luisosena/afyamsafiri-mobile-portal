class User {
  const User({
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
}