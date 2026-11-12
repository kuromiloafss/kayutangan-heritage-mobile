import '../../domain/entities/order.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/entities/ticket_form_defaults.dart';
import '../../domain/repositories/ticket_repository.dart';

class TicketRepositoryMemory implements TicketRepository {
  static const _formDefaults = TicketFormDefaults(
    visitorName: 'Budi Galaksi',
    visitDate: '9 September 2026',
    visitTime: '10.35',
    category: 'Lokal',
    ticketCount: 1,
    location: 'Kayutangan Heritage',
    subLocation: 'Malang',
  );

  final List<Ticket> _tickets = [
    const Ticket(
      ticketCode: 'KH-20072210-13',
      visitorName: 'Budi Galaksi',
      visitDate: '9 Sep 2026',
      visitTime: '10.35',
      category: 'Lokal',
      ticketCount: 1,
      pricePerTicket: 5000,
      totalPrice: 5000,
      location: 'Kayutangan Heritage',
      subLocation: 'Malang',
      isActive: true,
    ),
    const Ticket(
      ticketCode: 'KH-19090114-08',
      visitorName: 'Budi Galaksi',
      visitDate: '1 Sep 2026',
      visitTime: '14.32',
      category: 'Lokal',
      ticketCount: 1,
      pricePerTicket: 5000,
      totalPrice: 5000,
      location: 'Kayutangan Heritage',
      subLocation: 'Malang',
      isActive: false,
      historyTimestamp: '1 Sep 2026 - 14.32 WIB',
    ),
    const Ticket(
      ticketCode: 'KH-19102518-22',
      visitorName: 'Budi Galaksi',
      visitDate: '25 Okt 2026',
      visitTime: '18.38',
      category: 'Lokal',
      ticketCount: 1,
      pricePerTicket: 5000,
      totalPrice: 5000,
      location: 'Kayutangan Heritage',
      subLocation: 'Malang',
      isActive: false,
      historyTimestamp: '25 Okt 2026 - 18.38 WIB',
    ),
  ];

  final Map<String, Order> _orders = {};
  int _nextOrderId = 1;
  int _nextTicketCode = 14;

  @override
  TicketFormDefaults getFormDefaults() => _formDefaults;

  @override
  int getPricePerTicket(String category) {
    switch (category) {
      case 'Lokal':
        return 5000;
      case 'Turis':
        return 10000;
      default:
        throw ArgumentError('Kategori pengunjung tidak valid.');
    }
  }

  @override
  Order createOrder({
    required String visitorName,
    required String visitDate,
    required String visitTime,
    required String category,
    required int ticketCount,
    required int pricePerTicket,
    required int totalPrice,
    required String location,
  }) {
    final order = Order(
      id: 'order-${_nextOrderId++}',
      visitorName: visitorName,
      visitDate: visitDate,
      visitTime: visitTime,
      category: category,
      ticketCount: ticketCount,
      pricePerTicket: pricePerTicket,
      totalPrice: totalPrice,
      location: location,
    );
    _orders[order.id] = order;
    return order;
  }

  @override
  Order? getOrderById(String orderId) => _orders[orderId];

  @override
  void markOrderPaid(String orderId) {
    final order = _orders[orderId];
    if (order == null) {
      throw StateError('Pesanan tidak ditemukan.');
    }
    _orders[orderId] = order.copyWith(isPaid: true);
  }

  @override
  String createTicketCode() => 'KH-20072210-${_nextTicketCode++}';

  @override
  void saveTicket(Ticket ticket) {
    for (var index = 0; index < _tickets.length; index++) {
      final existingTicket = _tickets[index];
      if (existingTicket.isActive) {
        _tickets[index] = existingTicket.copyWith(
          isActive: false,
          historyTimestamp:
              '${existingTicket.visitDate} - ${existingTicket.visitTime} WIB',
        );
      }
    }
    _tickets.insert(0, ticket);
  }

  @override
  List<Ticket> getMyTickets() => List.unmodifiable(_tickets);

  @override
  Ticket? getTicketByCode(String ticketCode) {
    for (final ticket in _tickets) {
      if (ticket.ticketCode == ticketCode) return ticket;
    }
    return null;
  }

  @override
  void markTicketUsed(String ticketCode) {
    final index = _tickets.indexWhere(
      (ticket) => ticket.ticketCode == ticketCode,
    );
    if (index == -1) {
      throw StateError('Tiket tidak ditemukan.');
    }
    final ticket = _tickets[index];
    _tickets[index] = ticket.copyWith(
      isActive: false,
      historyTimestamp: '${ticket.visitDate} - ${ticket.visitTime} WIB',
    );
  }
}
