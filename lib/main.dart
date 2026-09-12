import 'package:flutter/material.dart';
import 'app.dart';
import 'core/services/dhis2_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dhis2Service = DHIS2Service();
  await dhis2Service.init();

  runApp(AfyaMsafiriApp(dhis2Service: dhis2Service));
}