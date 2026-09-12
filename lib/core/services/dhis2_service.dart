import 'package:d2_touch/d2_touch.dart';
import 'package:d2_touch/modules/auth/models/login-response.model.dart';
import 'package:d2_touch/modules/auth/entities/user.entity.dart';
import 'package:d2_touch/shared/models/request_progress.model.dart';
import 'package:flutter/foundation.dart';

class DHIS2Service {
  DHIS2Service({
    required this.serverUrl,
    this.mediatorUrl = 'https://afyamsafiri.moh.go.tz/mediator/api',
  });

  /// The DHIS2 server URL (e.g. https://play.dhis2.org/2.39.0).
  /// d2_touch connects directly to this — NOT the mediator.
  final String serverUrl;

  /// The mediator API URL, used for metadata proxying if needed.
  final String mediatorUrl;

  D2Touch? _d2;

  D2Touch get d2 {
    assert(_d2 != null, 'DHIS2Service not initialized. Call init() first.');
    return _d2!;
  }

  Future<bool> init() async {
    try {
      _d2 = await D2Touch.init();
      return true;
    } catch (_) {
      _d2 = null;
      return false;
    }
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
    await d2.programModule.program.download(_logProgress);
    await d2.programModule.programStage.download(_logProgress);
    await d2.programModule.programRule.download(_logProgress);
    await d2.programModule.trackedEntityAttribute.download(_logProgress);
    await d2.organisationUnitModule.organisationUnit.download(_logProgress);
    await d2.dataElementModule.dataElement.download(_logProgress);
  }

  Future<void> syncEvents() async {
    await d2.trackerModule.trackedEntityInstance.upload(_logProgress);
    await d2.trackerModule.event.upload(_logProgress);
  }

  Future<int> getPendingCount() async {
    final dirtyTeis = await d2.trackerModule.trackedEntityInstance
        .where(attribute: 'synced', value: false)
        .where(attribute: 'dirty', value: true)
        .get();
    final dirtyEvents = await d2.trackerModule.event
        .where(attribute: 'synced', value: false)
        .where(attribute: 'dirty', value: true)
        .get();
    return (dirtyTeis?.length ?? 0) + (dirtyEvents?.length ?? 0);
  }

  static void _logProgress(RequestProgress progress, bool done) {
    debugPrint('[DHIS2Sync] ${progress.percentage}% — ${progress.message}');
  }
}
