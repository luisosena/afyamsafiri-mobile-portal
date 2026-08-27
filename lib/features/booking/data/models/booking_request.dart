class BookingRequest {
  const BookingRequest({
    required this.pointOfEntry,
    required this.arrivalDate,
    required this.arrivalTime,
    this.flightNumber,
  });

  final String pointOfEntry;
  final String arrivalDate;
  final String arrivalTime;
  final String? flightNumber;

  Map<String, dynamic> toJson() => {
        'pointOfEntry': pointOfEntry,
        'arrivalDate': arrivalDate,
        'arrivalTime': arrivalTime,
        if (flightNumber != null) 'flightNumber': flightNumber,
      };
}