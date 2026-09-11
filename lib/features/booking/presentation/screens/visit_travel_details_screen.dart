import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/atoms/select_dropdown.dart';
import '../../../../shared/widgets/atoms/text_input.dart';
import '../providers/booking_provider.dart';
import '../widgets/arrival_form_section.dart';
import '../widgets/arrival_wizard_scaffold.dart';

class VisitTravelDetailsScreen extends StatefulWidget {
  const VisitTravelDetailsScreen({super.key});

  @override
  State<VisitTravelDetailsScreen> createState() =>
      _VisitTravelDetailsScreenState();
}

class _VisitTravelDetailsScreenState extends State<VisitTravelDetailsScreen> {
  final _vesselController = TextEditingController();
  final _seatController = TextEditingController();
  final _durationController = TextEditingController();
  final _addressController = TextEditingController();
  final _hotelController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _countriesCountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<BookingProvider>();
      provider.loadCountries();
      provider.loadPurposesOfVisit();
    });
  }

  @override
  void dispose() {
    _vesselController.dispose();
    _seatController.dispose();
    _durationController.dispose();
    _addressController.dispose();
    _hotelController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _countriesCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();

    return ArrivalWizardScaffold(
      currentStep: 2,
      title: 'Visit & Travel Details',
      onBack: () => context.go('/booking/traveler'),
      onCancel: () => context.go('/home'),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.containerPadding,
          vertical: AppSpacing.md,
        ),
        child: Column(
          children: [
            ArrivalFormSection(
              title: 'Arrival information',
              children: [
                TextInput(
                  controller: _vesselController,
                  label: 'Vessel/Flight/Vehicle Name/No',
                  hint: 'Enter Vessel/Flight/Vehicle Name/No',
                  onChanged: provider.setVesselName,
                ),
                const SizedBox(height: AppSpacing.md),
                TextInput(
                  controller: _seatController,
                  label: 'Seat number',
                  hint: 'Enter Seat number',
                  onChanged: provider.setSeatNumber,
                ),
                const SizedBox(height: AppSpacing.md),
                SelectDropdown(
                  label: 'Purpose of Visit in Tanzania',
                  hint: 'Select Purpose of Visit',
                  value: provider.booking.purposeOfVisit.isEmpty
                      ? null
                      : provider.booking.purposeOfVisit,
                  items: provider.purposesOfVisit,
                  required: true,
                  onChanged: provider.setPurposeOfVisit,
                ),
                const SizedBox(height: AppSpacing.md),
                TextInput(
                  controller: _durationController,
                  label: 'Duration of stay in Tanzania (days)',
                  hint: 'Enter Duration of stay in Tanzania (days)',
                  keyboardType: TextInputType.number,
                  onChanged: provider.setDurationOfStay,
                ),
              ],
            ),
            ArrivalFormSection(
              title: 'Contact while in Tanzania',
              children: [
                TextInput(
                  controller: _addressController,
                  label: 'Physical/Home Address',
                  hint: 'Enter Physical/Home Address',
                  onChanged: provider.setLocalAddress,
                ),
                const SizedBox(height: AppSpacing.md),
                TextInput(
                  controller: _hotelController,
                  label: 'Hotel name',
                  hint: 'Enter Hotel name',
                  onChanged: provider.setHotelName,
                ),
                const SizedBox(height: AppSpacing.md),
                TextInput(
                  controller: _phoneController,
                  label: 'Phone number',
                  hint: 'Enter Phone number',
                  keyboardType: TextInputType.phone,
                  required: true,
                  onChanged: provider.setLocalPhone,
                ),
                const SizedBox(height: AppSpacing.md),
                TextInput(
                  controller: _emailController,
                  label: 'Email address',
                  hint: 'Enter Email address',
                  keyboardType: TextInputType.emailAddress,
                  required: true,
                  onChanged: provider.setEmail,
                ),
              ],
            ),
            ArrivalFormSection(
              title: 'Travel History',
              children: [
                SelectDropdown(
                  label: 'Country where journey started',
                  hint: 'Select Country',
                  value: provider.booking.journeyStartCountry.isEmpty
                      ? null
                      : provider.booking.journeyStartCountry,
                  items: provider.countries,
                  required: true,
                  onChanged: provider.setJourneyStartCountry,
                ),
                const SizedBox(height: AppSpacing.md),
                TextInput(
                  controller: _countriesCountController,
                  label:
                      'Number of countries in the last 21 days (Put 0 if no any country visited)',
                  hint:
                      'Enter Number of countries in the last 21 days (Put 0 if no any country visited)',
                  keyboardType: TextInputType.number,
                  onChanged: provider.setCountriesVisitedCount,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: provider.isStep3Valid
                    ? () => context.go('/booking/health')
                    : null,
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}