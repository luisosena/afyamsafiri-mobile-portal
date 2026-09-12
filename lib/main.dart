import 'package:flutter/material.dart';
import 'app.dart';
import 'core/services/dhis2_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DHIS2Service? dhis2Service;
  try {
    dhis2Service = DHIS2Service(
      serverUrl: const String.fromEnvironment('DHIS2_URL'),
    );
    final ok = await dhis2Service.init();
    if (!ok) dhis2Service = null;
  } catch (_) {
    dhis2Service = null;
  }

  runApp(AfyaMsafiriApp(dhis2Service: dhis2Service));
}
