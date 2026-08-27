import '../entities/profile.dart';

abstract class ProfileRepository {
  Future<Profile> getProfile();

  Future<Profile> updateProfile({
    String? fullName,
    String? email,
    String? phone,
    String? nationality,
    String? passportNumber,
  });
}