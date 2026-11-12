import '../entities/ticket.dart';
import '../repositories/ticket_repository.dart';
import 'hitung_total.dart';

class ProsesPembayaran {
  static const paymentTimeoutSeconds = 600;

  final TicketRepository repository;
  final HitungTotal hitungTotal;

  const ProsesPembayaran({required this.repository, required this.hitungTotal});

  Ticket execute({required String orderId, required int remainingSeconds}) {
    if (orderId.trim().isEmpty) {
      throw ArgumentError('Pesanan tidak valid.');
    }
    if (remainingSeconds <= 0) {
      throw StateError('Waktu pembayaran telah habis.');
    }

    final order = repository.getOrderById(orderId);
    if (order == null) {
      throw StateError('Pesanan tidak ditemukan.');
    }
    if (order.isPaid) {
      throw StateError('Pesanan sudah dibayar.');
    }
    final expectedTotal = hitungTotal.execute(
      category: order.category,
      ticketCount: order.ticketCount,
    );
    if (expectedTotal != order.totalPrice ||
        order.pricePerTicket * order.ticketCount != order.totalPrice) {
      throw StateError('Total pembayaran tidak valid.');
    }

    final ticket = Ticket(
      ticketCode: repository.createTicketCode(),
      visitorName: order.visitorName,
      visitDate: order.visitDate,
      visitTime: order.visitTime,
      category: order.category,
      ticketCount: order.ticketCount,
      pricePerTicket: order.pricePerTicket,
      totalPrice: order.totalPrice,
      location: order.location,
      subLocation: repository.getFormDefaults().subLocation,
      isActive: true,
    );
    repository.markOrderPaid(order.id);
    repository.saveTicket(ticket);
    return ticket;
  }
}
