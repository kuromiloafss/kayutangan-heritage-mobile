class Ticket {
  final String ticketCode;
  final String visitorName;
  final String visitDate;
  final String visitTime;
  final String category;
  final int ticketCount;
  final int pricePerTicket;
  final int totalPrice;
  final String location;
  final String subLocation;
  final bool isActive;
  final String historyTimestamp;

  const Ticket({
    required this.ticketCode,
    required this.visitorName,
    required this.visitDate,
    required this.visitTime,
    required this.category,
    required this.ticketCount,
    required this.pricePerTicket,
    required this.totalPrice,
    required this.location,
    required this.subLocation,
    required this.isActive,
    this.historyTimestamp = '',
  });

  Ticket copyWith({bool? isActive, String? historyTimestamp}) => Ticket(
    ticketCode: ticketCode,
    visitorName: visitorName,
    visitDate: visitDate,
    visitTime: visitTime,
    category: category,
    ticketCount: ticketCount,
    pricePerTicket: pricePerTicket,
    totalPrice: totalPrice,
    location: location,
    subLocation: subLocation,
    isActive: isActive ?? this.isActive,
    historyTimestamp: historyTimestamp ?? this.historyTimestamp,
  );
}
