import 'package:flutter/material.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';

enum ProfileStatus { initial, loading, loaded, updating, error }

class ProfileProvider extends ChangeNotifier {
  ProfileProvider({required ProfileRepository profileRepository})
      : _repository = profileRepository;

  final ProfileRepository _repository;

  Profile? _profile;
  ProfileStatus _status = ProfileStatus.initial;
  String? _errorMessage;
  bool _isEditing = false;

  Profile? get profile => _profile;
  ProfileStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isEditing => _isEditing;

  Future<void> loadProfile() async {
    _status = ProfileStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = await _repository.getProfile();
      _status = ProfileStatus.loaded;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _status = ProfileStatus.error;
    }
    notifyListeners();
  }

  Future<bool> updateProfile({
    String? fullName,
    String? email,
    String? phone,
    String? nationality,
    String? passportNumber,
  }) async {
    _status = ProfileStatus.updating;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = await _repository.updateProfile(
        fullName: fullName,
        email: email,
        phone: phone,
        nationality: nationality,
        passportNumber: passportNumber,
      );
      _isEditing = false;
      _status = ProfileStatus.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _status = ProfileStatus.loaded;
      notifyListeners();
      return false;
    }
  }

  void toggleEditing() {
    _isEditing = !_isEditing;
    _errorMessage = null;
    notifyListeners();
  }

  void cancelEditing() {
    _isEditing = false;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
