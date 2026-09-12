import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afyamsafiri/core/providers/sync_provider.dart';
import 'package:afyamsafiri/core/services/dhis2_service.dart';

class MockDHIS2Service extends Mock implements DHIS2Service {}

void main() {
  late MockDHIS2Service mockService;
  late SyncProvider provider;

  setUp(() {
    mockService = MockDHIS2Service();
    provider = SyncProvider(dhis2Service: mockService);
  });

  group('SyncProvider', () {
    test('initial state is correct', () {
      expect(provider.state, SyncState.idle);
      expect(provider.errorMessage, isNull);
      expect(provider.pendingCount, 0);
      expect(provider.isSyncing, isFalse);
    });

    group('sync', () {
      test('transitions idle → syncing → success on success', () async {
        when(() => mockService.syncEvents()).thenAnswer((_) async {});
        when(() => mockService.getPendingCount()).thenAnswer((_) async => 0);

        final states = <SyncState>[];
        provider.addListener(() => states.add(provider.state));

        await provider.sync();

        expect(states, [SyncState.syncing, SyncState.success]);
        expect(provider.errorMessage, isNull);
        expect(provider.pendingCount, 0);
      });

      test('transitions idle → syncing → error on failure', () async {
        when(() => mockService.syncEvents())
            .thenThrow(Exception('Network error'));

        final states = <SyncState>[];
        provider.addListener(() => states.add(provider.state));

        await provider.sync();

        expect(states, [SyncState.syncing, SyncState.error]);
        expect(provider.errorMessage, contains('Network error'));
      });

      test('does not sync when already syncing', () async {
        when(() => mockService.syncEvents()).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
        });
        when(() => mockService.getPendingCount()).thenAnswer((_) async => 0);

        final future1 = provider.sync();
        await provider.sync();

        await future1;
        verify(() => mockService.syncEvents()).called(1);
      });

      test('updates pending count after successful sync', () async {
        when(() => mockService.syncEvents()).thenAnswer((_) async {});
        when(() => mockService.getPendingCount()).thenAnswer((_) async => 3);

        await provider.sync();

        expect(provider.pendingCount, 3);
      });

      test('clears error message on new sync attempt', () async {
        when(() => mockService.syncEvents())
            .thenThrow(Exception('First error'));
        await provider.sync();
        expect(provider.errorMessage, isNotNull);

        when(() => mockService.syncEvents()).thenAnswer((_) async {});
        when(() => mockService.getPendingCount()).thenAnswer((_) async => 0);
        await provider.sync();

        expect(provider.errorMessage, isNull);
      });
    });

    group('updatePendingCount', () {
      test('updates pending count from service', () async {
        when(() => mockService.getPendingCount()).thenAnswer((_) async => 5);

        await provider.updatePendingCount();

        expect(provider.pendingCount, 5);
      });

      test('notifies listeners', () async {
        when(() => mockService.getPendingCount()).thenAnswer((_) async => 2);

        var notified = false;
        provider.addListener(() => notified = true);

        await provider.updatePendingCount();

        expect(notified, isTrue);
      });
    });

    group('reset', () {
      test('resets to idle state', () async {
        when(() => mockService.syncEvents())
            .thenThrow(Exception('error'));
        await provider.sync();
        expect(provider.state, SyncState.error);

        provider.reset();

        expect(provider.state, SyncState.idle);
        expect(provider.errorMessage, isNull);
      });

      test('notifies listeners', () {
        var notified = false;
        provider.addListener(() => notified = true);

        provider.reset();

        expect(notified, isTrue);
      });
    });
  });
}
