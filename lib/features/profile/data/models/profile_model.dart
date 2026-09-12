import '../../domain/entities/profile.dart';

class ProfileModel {
  const ProfileModel({
    required this.id,
    required this.fullName,
    this.phone,
    this.nationality,
    this.passportNumber,
    this.profileImageUrl,
  });

  final String id;
  final String fullName;
  final String? phone;
  final String? nationality;
  final String? passportNumber;
  final String? profileImageUrl;

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String?,
      nationality: json['nationality'] as String?,
      passportNumber: json['passportNumber'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }

  Profile toEntity() {
    return Profile(
      id: id,
      fullName: fullName,
      phone: phone,
      nationality: nationality,
      passportNumber: passportNumber,
      profileImageUrl: profileImageUrl,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        if (phone != null) 'phone': phone,
        if (nationality != null) 'nationality': nationality,
        if (passportNumber != null) 'passportNumber': passportNumber,
        if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      };
}