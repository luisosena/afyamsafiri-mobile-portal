import 'package:d2_touch/modules/auth/entities/user.entity.dart';
import '../../domain/entities/profile.dart';

Profile mapD2UserToProfile(User user) {
  return Profile(
    id: user.id ?? '',
    fullName: '${user.firstName} ${user.surname ?? ''}'.trim(),
    email: user.username ?? '',
    phone: user.phoneNumber,
  );
}