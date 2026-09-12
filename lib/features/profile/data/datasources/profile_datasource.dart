import '../models/profile_model.dart';

abstract class ProfileDataSource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile({
    String? fullName,
    String? phone,
    String? nationality,
    String? passportNumber,
  });
}
