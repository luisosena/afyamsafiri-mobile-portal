import 'package:flutter/material.dart';
import '../../domain/entities/screening.dart';
import '../../domain/repositories/screening_repository.dart';

enum ScreeningStatus { initial, loading, submitting, success, error, saved }

class ScreeningProvider extends ChangeNotifier {
  ScreeningProvider({required this.screeningRepository});

  final ScreeningRepository screeningRepository;

  ScreeningStatus _status = ScreeningStatus.initial;
  int _currentStep = 0;
  String? _errorMessage;

  ScreeningStatus get status => _status;
  int get currentStep => _currentStep;
  String? get errorMessage => _errorMessage;

  static const int totalSteps = 5;

  // Step 1: Travel History
  final List<String> _countries = [];
  List<String> get countries => List.unmodifiable(_countries);

  // Step 2: Symptoms
  final List<Symptom> _symptoms = [
    const Symptom(id: 'fever', name: 'Fever'),
    const Symptom(id: 'cough', name: 'Cough'),
    const Symptom(id: 'breathing', name: 'Breathing Difficulty'),
    const Symptom(id: 'vomiting', name: 'Vomiting / Diarrhea'),
    const Symptom(id: 'other', name: 'Other'),
  ];
  List<Symptom> get symptoms => List.unmodifiable(_symptoms);
  bool _noneSymptoms = false;
  bool get noneSymptoms => _noneSymptoms;

  // Step 3: Vaccination
  bool? _isVaccinated;
  String? _certificateFilePath;
  bool? get isVaccinated => _isVaccinated;
  String? get certificateFilePath => _certificateFilePath;

  // Step 4: Additional Health
  bool? _hasContactWithInfectiousDisease;
  bool? _isMedicalTravelPurpose;
  bool? get hasContactWithInfectiousDisease => _hasContactWithInfectiousDisease;
  bool? get isMedicalTravelPurpose => _isMedicalTravelPurpose;

  // Step 5: Declaration
  bool _declarationAccepted = false;
  bool get declarationAccepted => _declarationAccepted;

  // Validation per step
  bool get isStep1Valid => _countries.isNotEmpty;
  bool get isStep2Valid => _noneSymptoms || _symptoms.any((s) => s.selected);
  bool get isStep3Valid => _isVaccinated != null;
  bool get isStep4Valid =>
      _hasContactWithInfectiousDisease != null &&
      _isMedicalTravelPurpose != null;
  bool get isStep5Valid => _declarationAccepted;

  bool get isCurrentStepValid {
    switch (_currentStep) {
      case 0:
        return isStep1Valid;
      case 1:
        return isStep2Valid;
      case 2:
        return isStep3Valid;
      case 3:
        return isStep4Valid;
      case 4:
        return isStep5Valid;
      default:
        return false;
    }
  }

  bool get canGoNext => _currentStep < totalSteps - 1 && isCurrentStepValid;
  bool get canGoBack => _currentStep > 0;
  bool get isLastStep => _currentStep == totalSteps - 1;

  void nextStep() {
    if (canGoNext) {
      _currentStep++;
      notifyListeners();
    }
  }

  void prevStep() {
    if (canGoBack) {
      _currentStep--;
      notifyListeners();
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step < totalSteps) {
      _currentStep = step;
      notifyListeners();
    }
  }

  // Step 1: Travel History
  void addCountry(String country) {
    final trimmed = country.trim();
    if (trimmed.isNotEmpty && !_countries.contains(trimmed)) {
      _countries.add(trimmed);
      notifyListeners();
    }
  }

  void removeCountry(String country) {
    _countries.remove(country);
    notifyListeners();
  }

  // Step 2: Symptoms
  void toggleSymptom(String id) {
    final index = _symptoms.indexWhere((s) => s.id == id);
    if (index != -1) {
      _symptoms[index] = Symptom(
        id: _symptoms[index].id,
        name: _symptoms[index].name,
        selected: !_symptoms[index].selected,
      );
      if (_symptoms[index].selected) _noneSymptoms = false;
      notifyListeners();
    }
  }

  void setNoneSymptoms(bool value) {
    _noneSymptoms = value;
    if (value) {
      for (var i = 0; i < _symptoms.length; i++) {
        _symptoms[i] = Symptom(
          id: _symptoms[i].id,
          name: _symptoms[i].name,
          selected: false,
        );
      }
    }
    notifyListeners();
  }

  // Step 3: Vaccination
  void setVaccinated(bool? value) {
    _isVaccinated = value;
    if (value != true) _certificateFilePath = null;
    notifyListeners();
  }

  void setCertificatePath(String? path) {
    _certificateFilePath = path;
    notifyListeners();
  }

  // Step 4: Additional Health
  void setContactWithInfectiousDisease(bool? value) {
    _hasContactWithInfectiousDisease = value;
    notifyListeners();
  }

  void setMedicalTravelPurpose(bool? value) {
    _isMedicalTravelPurpose = value;
    notifyListeners();
  }

  // Step 5: Declaration
  void setDeclarationAccepted(bool value) {
    _declarationAccepted = value;
    notifyListeners();
  }

  Screening _buildScreening() {
    return Screening(
      travelHistory: TravelHistory(countries: List.from(_countries)),
      symptoms: List.from(_symptoms),
      vaccinationInfo: VaccinationInfo(
        isVaccinated: _isVaccinated,
        certificateFilePath: _certificateFilePath,
      ),
      additionalHealthInfo: AdditionalHealthInfo(
        hasContactWithInfectiousDisease: _hasContactWithInfectiousDisease,
        isMedicalTravelPurpose: _isMedicalTravelPurpose,
      ),
      declarationAccepted: _declarationAccepted,
    );
  }

  Future<void> submitScreening(String bookingId) async {
    _status = ScreeningStatus.submitting;
    _errorMessage = null;
    notifyListeners();

    try {
      await screeningRepository.submitScreening(
        bookingId: bookingId,
        screening: _buildScreening(),
      );
      _status = ScreeningStatus.success;
    } catch (e) {
      _status = ScreeningStatus.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    }
    notifyListeners();
  }

  Future<void> saveDraft(String bookingId) async {
    _status = ScreeningStatus.loading;
    notifyListeners();

    try {
      await screeningRepository.saveDraft(
        bookingId: bookingId,
        screening: _buildScreening(),
      );
      _status = ScreeningStatus.saved;
    } catch (e) {
      _status = ScreeningStatus.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    }
    notifyListeners();
  }

  void reset() {
    _status = ScreeningStatus.initial;
    _currentStep = 0;
    _errorMessage = null;
    _countries.clear();
    for (var i = 0; i < _symptoms.length; i++) {
      _symptoms[i] = Symptom(
        id: _symptoms[i].id,
        name: _symptoms[i].name,
        selected: false,
      );
    }
    _noneSymptoms = false;
    _isVaccinated = null;
    _certificateFilePath = null;
    _hasContactWithInfectiousDisease = null;
    _isMedicalTravelPurpose = null;
    _declarationAccepted = false;
    notifyListeners();
  }
}
