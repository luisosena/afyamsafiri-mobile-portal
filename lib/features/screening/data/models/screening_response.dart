class ScreeningResponse {
  const ScreeningResponse({
    required this.screeningId,
    required this.bookingId,
    this.status,
    this.submittedAt,
  });

  final String screeningId;
  final String bookingId;
  final String? status;
  final String? submittedAt;

  factory ScreeningResponse.fromJson(Map<String, dynamic> json) {
    return ScreeningResponse(
      screeningId: json['screeningId'] as String,
      bookingId: json['bookingId'] as String,
      status: json['status'] as String?,
      submittedAt: json['submittedAt'] as String?,
    );
  }
}