class RegistrationRequest {
  const RegistrationRequest({
    required this.fullName,
    required this.email,
    required this.password,
    this.phone,
    this.nationality,
    this.passportNumber,
  });

  final String fullName;
  final String email;
  final String password;
  final String? phone;
  final String? nationality;
  final String? passportNumber;

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'email': email,
        'password': password,
        if (phone != null) 'phone': phone,
        if (nationality != null) 'nationality': nationality,
        if (passportNumber != null) 'passportNumber': passportNumber,
      };
}