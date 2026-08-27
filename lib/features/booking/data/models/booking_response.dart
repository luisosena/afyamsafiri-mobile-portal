import '../../domain/entities/booking.dart';

class BookingResponse {
  const BookingResponse({
    required this.id,
    required this.referenceCode,
    this.pointOfEntry,
    this.arrivalDate,
    this.arrivalTime,
    this.flightNumber,
    required this.status,
    this.qrCodeData,
    this.createdAt,
    this.updatedAt,
    this.userId,
  });

  final String id;
  final String referenceCode;
  final String? pointOfEntry;
  final String? arrivalDate;
  final String? arrivalTime;
  final String? flightNumber;
  final String status;
  final String? qrCodeData;
  final String? createdAt;
  final String? updatedAt;
  final String? userId;

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      id: json['id'] as String,
      referenceCode: json['referenceCode'] as String,
      pointOfEntry: json['pointOfEntry'] as String?,
      arrivalDate: json['arrivalDate'] as String?,
      arrivalTime: json['arrivalTime'] as String?,
      flightNumber: json['flightNumber'] as String?,
      status: json['status'] as String,
      qrCodeData: json['qrCodeData'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      userId: json['userId'] as String?,
    );
  }

  Booking toEntity() {
    return Booking(
      id: id,
      referenceCode: referenceCode,
      pointOfEntry: pointOfEntry,
      arrivalDate: arrivalDate,
      arrivalTime: arrivalTime,
      flightNumber: flightNumber,
      status: BookingStatus.values.firstWhere(
        (e) => e.name == status,
        orElse: () => BookingStatus.pending,
      ),
      qrCodeData: qrCodeData,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
      userId: userId,
    );
  }
}