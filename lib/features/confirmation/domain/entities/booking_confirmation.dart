class BookingConfirmation {
  const BookingConfirmation({
    required this.referenceCode,
    required this.qrCodeData,
    this.travellerName,
    this.entryDate,
    this.entryTime,
    this.pointOfEntry,
    this.status,
  });

  final String referenceCode;
  final String qrCodeData;
  final String? travellerName;
  final String? entryDate;
  final String? entryTime;
  final String? pointOfEntry;
  final String? status;
}