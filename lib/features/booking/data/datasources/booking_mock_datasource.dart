import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'booking_datasource.dart';

class BookingMockDataSource implements BookingDataSource {
  SharedPreferences? _prefs;
  bool _initialized = false;
  List<Map<String, dynamic>> _bookings = [];

  static const _storageKey = 'afyamsafiri_bookings';

  static const List<Map<String, dynamic>> _defaultSeedData = [
    {
      'id': 'ad-001',
      'referenceCode': 'TZ-2026-001',
      'status': 'submitted',
      'passportNumber': 'AB1234567',
      'portOfEntry': 'Julius Nyerere International Airport',
      'arrivalDate': '2026-09-15T00:00:00Z',
      'firstName': 'John',
      'middleName': '',
      'surname': 'Doe',
      'gender': 'Male',
      'dateOfBirth': '1990-05-15T00:00:00Z',
      'nationality': 'American',
      'vesselName': 'KQ480',
      'seatNumber': '14A',
      'purposeOfVisit': 'Tourism',
      'durationOfStay': '7',
      'localPhone': '+255712345678',
      'email': 'john.doe@email.com',
      'journeyStartCountry': 'Kenya',
      'createdAt': '2026-09-01T10:00:00Z',
      'updatedAt': '2026-09-01T10:00:00Z',
    },
  ];

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    final stored = _prefs!.getString(_storageKey);
    if (stored != null) {
      final decoded = jsonDecode(stored) as List;
      _bookings = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    } else {
      _bookings = List<Map<String, dynamic>>.from(_defaultSeedData);
      await _save();
    }
    _initialized = true;
  }

  Future<void> _save() async {
    await _prefs?.setString(_storageKey, jsonEncode(_bookings));
  }

  @override
  Future<Map<String, dynamic>> submitBooking(
    Map<String, dynamic> data,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    await _ensureInitialized();

    final entry = {
      'id': 'bk-${DateTime.now().millisecondsSinceEpoch}',
      'referenceCode': 'TZ-${DateTime.now().millisecondsSinceEpoch}',
      'status': 'submitted',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      ...data,
    };

    _bookings.add(entry);
    await _save();
    return entry;
  }

  @override
  Future<List<Map<String, dynamic>>> getBookings() async {
    await Future.delayed(const Duration(milliseconds: 800));
    await _ensureInitialized();
    return List.from(_bookings);
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    await Future.delayed(const Duration(seconds: 1));
    await _ensureInitialized();
    final index = _bookings.indexWhere((d) => d['id'] == bookingId);
    if (index == -1) throw Exception('Booking not found');
    _bookings[index]['status'] = 'cancelled';
    _bookings[index]['updatedAt'] = DateTime.now().toIso8601String();
    await _save();
  }

  @override
  Future<List<String>> getPortsOfEntry() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return [
      'Julius Nyerere International Airport',
      'Kilimanjaro International Airport',
      'Abeid Amani Karume International Airport',
      'Mwanza Airport',
      'Namanga Border Post',
      'Tunduma Border Post',
      'Horohoro Border Post',
      'Rusumo Border Post',
      'Dar es Salaam Port',
      'Tanga Port',
      'Mtwara Port',
      'Zanzibar Port',
    ];
  }

  @override
  Future<List<String>> getNationalities() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return [
      'Tanzanian',
      'Kenyan',
      'Ugandan',
      'Rwandan',
      'Burundian',
      'South Sudanese',
      'Congolese (DRC)',
      'Ethiopian',
      'Somali',
      'Mozambican',
      'Malawian',
      'Zambian',
      'Zimbabwean',
      'South African',
      'Nigerian',
      'Ghanaian',
      'Indian',
      'Chinese',
      'American',
      'British',
      'German',
      'French',
      'Dutch',
      'Canadian',
      'Australian',
      'Other',
    ];
  }

  @override
  Future<List<String>> getCountries() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return [
      'Afghanistan',
      'Albania',
      'Algeria',
      'Angola',
      'Argentina',
      'Australia',
      'Austria',
      'Bangladesh',
      'Belgium',
      'Benin',
      'Bolivia',
      'Botswana',
      'Brazil',
      'Burkina Faso',
      'Burundi',
      'Cambodia',
      'Cameroon',
      'Canada',
      'Central African Republic',
      'Chad',
      'Chile',
      'China',
      'Colombia',
      'Congo',
      'Costa Rica',
      'Croatia',
      'Cuba',
      'Cyprus',
      'Czech Republic',
      'DR Congo',
      'Denmark',
      'Djibouti',
      'Ecuador',
      'Egypt',
      'El Salvador',
      'Equatorial Guinea',
      'Eritrea',
      'Estonia',
      'Ethiopia',
      'Finland',
      'France',
      'Gabon',
      'Gambia',
      'Germany',
      'Ghana',
      'Greece',
      'Guatemala',
      'Guinea',
      'Guinea-Bissau',
      'Haiti',
      'Honduras',
      'Hungary',
      'India',
      'Indonesia',
      'Iran',
      'Iraq',
      'Ireland',
      'Israel',
      'Italy',
      'Ivory Coast',
      'Jamaica',
      'Japan',
      'Jordan',
      'Kazakhstan',
      'Kenya',
      'Kuwait',
      'Lebanon',
      'Lesotho',
      'Liberia',
      'Libya',
      'Madagascar',
      'Malawi',
      'Malaysia',
      'Mali',
      'Mauritania',
      'Mauritius',
      'Mexico',
      'Morocco',
      'Mozambique',
      'Myanmar',
      'Namibia',
      'Nepal',
      'Netherlands',
      'New Zealand',
      'Nicaragua',
      'Niger',
      'Nigeria',
      'North Korea',
      'Norway',
      'Oman',
      'Pakistan',
      'Palestine',
      'Panama',
      'Papua New Guinea',
      'Paraguay',
      'Peru',
      'Philippines',
      'Poland',
      'Portugal',
      'Qatar',
      'Romania',
      'Russia',
      'Rwanda',
      'Saudi Arabia',
      'Senegal',
      'Serbia',
      'Sierra Leone',
      'Singapore',
      'Somalia',
      'South Africa',
      'South Korea',
      'South Sudan',
      'Spain',
      'Sri Lanka',
      'Sudan',
      'Sweden',
      'Switzerland',
      'Syria',
      'Taiwan',
      'Thailand',
      'Togo',
      'Tunisia',
      'Turkey',
      'UAE',
      'Uganda',
      'Ukraine',
      'United Kingdom',
      'United States',
      'Uruguay',
      'Uzbekistan',
      'Venezuela',
      'Vietnam',
      'Yemen',
      'Zambia',
      'Zimbabwe',
    ];
  }

  @override
  Future<List<String>> getPurposesOfVisit() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return [
      'Tourism',
      'Business',
      'Transit',
      'Diplomatic',
      'Study/Education',
      'Medical',
      'Employment',
      'Conference/Meeting',
      'Visiting Family/Friends',
      'NGO/Humanitarian',
      'Research',
      'Other',
    ];
  }
}