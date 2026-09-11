import '../models/profile_model.dart';

abstract class ProfileDataSource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile({
    String? fullName,
    String? email,
    String? phone,
    String? nationality,
    String? passportNumber,
  });
}
