import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

const String serverUrl = 'https://afyamsafiri.moh.go.tz';
const String username = 'admin';
const String password = 'district';

Future<void> main() async {
  print('=== DHIS2 Discovery Script ===\n');
  print('Server: $serverUrl');
  print('User: $username\n');

  final dio = Dio(BaseOptions(
    headers: {
      HttpHeaders.authorizationHeader:
          'Basic ${base64Encode(utf8.encode('$username:$password'))}',
    },
  ));

  final api = '$serverUrl/api';

  // --- Programs ---
  print('=== PROGRAMS ===');
  final programsRes = await dio.get(
    '$api/programs',
    queryParameters: {
      'fields': 'id,name,programType,programStages[id,name,sortOrder]',
      'paging': 'false',
    },
  );
  final programs = programsRes.data['programs'] as List? ?? [];
  for (final p in programs) {
    print('  ${p['name']}');
    print('    ID: ${p['id']}');
    print('    Type: ${p['programType']}');
    final stages = p['programStages'] as List? ?? [];
    for (final s in stages) {
      print('    Stage [${s['sortOrder']}]: ${s['name']}');
      print('      ID: ${s['id']}');
    }
    print('');
  }

  // --- Tracked Entity Types ---
  print('=== TRACKED ENTITY TYPES ===');
  final tetRes = await dio.get(
    '$api/trackedEntityTypes',
    queryParameters: {
      'fields': 'id,name',
      'paging': 'false',
    },
  );
  final tets = tetRes.data['trackedEntityTypes'] as List? ?? [];
  for (final t in tets) {
    print('  ${t['name']}');
    print('    ID: ${t['id']}');
  }
  print('');

  // --- Organisation Units (top-level) ---
  print('=== ORGANISATION UNITS (Level 1-3) ===');
  final ouRes = await dio.get(
    '$api/organisationUnits',
    queryParameters: {
      'fields': 'id,name,level',
      'filter': 'level:le:3',
      'paging': 'false',
    },
  );
  final ous = ouRes.data['organisationUnits'] as List? ?? [];
  for (final ou in ous) {
    print('  [L${ou['level']}] ${ou['name']}');
    print('    ID: ${ou['id']}');
  }
  print('');

  // --- Data Elements for each program stage ---
  if (programs.isNotEmpty) {
    print('=== DATA ELEMENTS BY PROGRAM STAGE ===');
    for (final p in programs) {
      final stages = p['programStages'] as List? ?? [];
      for (final s in stages) {
        print('\n  Program: ${p['name']}');
        print('  Stage: ${s['name']}');
        print('  Stage ID: ${s['id']}');
        final psRes = await dio.get(
          '$api/programStages/${s['id']}',
          queryParameters: {
            'fields':
                'programStageDataElements[sortOrder,dataElement[id,name,code,valueType]]',
          },
        );
        final psdes =
            psRes.data['programStageDataElements'] as List? ?? [];
        for (final psde in psdes) {
          final de = psde['dataElement'];
          print('    [${psde['sortOrder']}] ${de['name']}');
          print('      ID: ${de['id']}');
          print('      Type: ${de['valueType']}');
        }
      }
    }
  }

  print('\n=== DONE ===');
}
