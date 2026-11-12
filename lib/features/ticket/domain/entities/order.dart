class Order {
  final String id;
  final String visitorName;
  final String visitDate;
  final String visitTime;
  final String category;
  final int ticketCount;
  final int pricePerTicket;
  final int totalPrice;
  final String location;
  final bool isPaid;

  const Order({
    required this.id,
    required this.visitorName,
    required this.visitDate,
    required this.visitTime,
    required this.category,
    required this.ticketCount,
    required this.pricePerTicket,
    required this.totalPrice,
    required this.location,
    this.isPaid = false,
  });

  Order copyWith({bool? isPaid}) => Order(
    id: id,
    visitorName: visitorName,
    visitDate: visitDate,
    visitTime: visitTime,
    category: category,
    ticketCount: ticketCount,
    pricePerTicket: pricePerTicket,
    totalPrice: totalPrice,
    location: location,
    isPaid: isPaid ?? this.isPaid,
  );
}
