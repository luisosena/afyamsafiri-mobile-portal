import '../models/profile_model.dart';

class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile() async {
    throw UnimplementedError('Remote API not yet available');
  }

  Future<ProfileModel> updateProfile({
    String? fullName,
    String? email,
    String? phone,
    String? nationality,
    String? passportNumber,
  }) async {
    throw UnimplementedError('Remote API not yet available');
  }
}