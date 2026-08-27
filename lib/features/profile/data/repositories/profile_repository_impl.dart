import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_mock_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({
    required this.remoteDataSource,
  });

  final ProfileMockDataSource remoteDataSource;

  @override
  Future<Profile> getProfile() async {
    final model = await remoteDataSource.getProfile();
    return model.toEntity();
  }

  @override
  Future<Profile> updateProfile({
    String? fullName,
    String? email,
    String? phone,
    String? nationality,
    String? passportNumber,
  }) async {
    final model = await remoteDataSource.updateProfile(
      fullName: fullName,
      email: email,
      phone: phone,
      nationality: nationality,
      passportNumber: passportNumber,
    );
    return model.toEntity();
  }
}