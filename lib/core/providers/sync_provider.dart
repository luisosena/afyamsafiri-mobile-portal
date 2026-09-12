import 'package:flutter/material.dart';
import '../services/dhis2_service.dart';

enum SyncState { idle, syncing, success, error }

class SyncProvider extends ChangeNotifier {
  SyncProvider({required this.dhis2Service});

  final DHIS2Service dhis2Service;

  SyncState _state = SyncState.idle;
  String? _errorMessage;
  int _pendingCount = 0;

  SyncState get state => _state;
  String? get errorMessage => _errorMessage;
  int get pendingCount => _pendingCount;
  bool get isSyncing => _state == SyncState.syncing;

  Future<void> sync() async {
    if (_state == SyncState.syncing) return;

    _state = SyncState.syncing;
    _errorMessage = null;
    notifyListeners();

    try {
      await dhis2Service.syncEvents();
      _pendingCount = await dhis2Service.getPendingCount();
      _state = SyncState.success;
    } catch (e) {
      _state = SyncState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> updatePendingCount() async {
    _pendingCount = await dhis2Service.getPendingCount();
    notifyListeners();
  }

  void reset() {
    _state = SyncState.idle;
    _errorMessage = null;
    notifyListeners();
  }
}
