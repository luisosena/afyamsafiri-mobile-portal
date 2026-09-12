import 'package:d2_touch/d2_touch.dart';
import 'package:d2_touch/modules/auth/models/login-response.model.dart';
import 'package:d2_touch/modules/auth/entities/user.entity.dart';
import 'package:d2_touch/shared/models/request_progress.model.dart';

class DHIS2Service {
  DHIS2Service({this.serverUrl = 'https://afyamsafiri.moh.go.tz'});

  final String serverUrl;
  D2Touch? _d2;

  D2Touch get d2 {
    assert(_d2 != null, 'DHIS2Service not initialized. Call init() first.');
    return _d2!;
  }

  Future<void> init() async {
    _d2 = await D2Touch.init();
  }

  Future<LoginResponseStatus> login({
    required String username,
    required String password,
  }) async {
    return d2.authModule.logIn(
      username: username,
      password: password,
      url: serverUrl,
    );
  }

  Future<void> logout() async {
    await d2.authModule.logOut();
  }

  Future<bool> isAuthenticated() async {
    return d2.authModule.isAuthenticated();
  }

  Future<User?> getCurrentUser() async {
    return d2.userModule.user.getOne();
  }

  Future<void> downloadMetadata() async {
    await d2.programModule.program
        .download(_noopProgress);
    await d2.organisationUnitModule.organisationUnit
        .download(_noopProgress);
    await d2.dataElementModule.dataElement
        .download(_noopProgress);
  }

  Future<void> syncEvents() async {
    await d2.trackerModule.trackedEntityInstance
        .upload(_noopProgress);
  }

  static void _noopProgress(RequestProgress progress, bool done) {}
}