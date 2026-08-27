enum BookingStatus {
  pending,
  confirmed,
  completed,
  cancelled,
  draft,
  pendingSync,
}

class Booking {
  const Booking({
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
  final BookingStatus status;
  final String? qrCodeData;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? userId;

  bool get isPending => status == BookingStatus.pending;
  bool get isConfirmed => status == BookingStatus.confirmed;
  bool get isCompleted => status == BookingStatus.completed;
  bool get isCancelled => status == BookingStatus.cancelled;
  bool get isDraft => status == BookingStatus.draft || status == BookingStatus.pendingSync;
}