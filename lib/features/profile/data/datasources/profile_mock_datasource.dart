import '../models/profile_model.dart';
import 'profile_datasource.dart';

class ProfileMockDataSource implements ProfileDataSource {
  final Map<String, dynamic> _profile = {
    'id': 'mock-user-001',
    'fullName': 'John Doe',
    'phone': '+255712345678',
    'nationality': 'Tanzania',
    'passportNumber': 'AB1234567',
  };

  @override
  Future<ProfileModel> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ProfileModel.fromJson(_profile);
  }

  @override
  Future<ProfileModel> updateProfile({
    String? fullName,
    String? phone,
    String? nationality,
    String? passportNumber,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (fullName != null) _profile['fullName'] = fullName;
    if (phone != null) _profile['phone'] = phone;
    if (nationality != null) _profile['nationality'] = nationality;
    if (passportNumber != null) _profile['passportNumber'] = passportNumber;

    return ProfileModel.fromJson(_profile);
  }
}
