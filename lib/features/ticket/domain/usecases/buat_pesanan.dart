import '../entities/order.dart';
import '../repositories/ticket_repository.dart';
import 'hitung_total.dart';

class BuatPesanan {
  final TicketRepository repository;
  final HitungTotal hitungTotal;

  const BuatPesanan({required this.repository, required this.hitungTotal});

  Order execute({
    required String visitorName,
    required String visitDate,
    required String visitTime,
    required String category,
    int? ticketCount,
  }) {
    final defaults = repository.getFormDefaults();
    final name = visitorName.trim().isEmpty
        ? defaults.visitorName
        : visitorName.trim();
    final date = visitDate.trim().isEmpty
        ? defaults.visitDate
        : visitDate.trim();
    final time = visitTime.trim().isEmpty
        ? defaults.visitTime
        : visitTime.trim();
    final selectedCategory = category.trim().isEmpty
        ? defaults.category
        : category.trim();
    final selectedTicketCount = ticketCount ?? defaults.ticketCount;
    final pricePerTicket = repository.getPricePerTicket(selectedCategory);
    final totalPrice = hitungTotal.execute(
      category: selectedCategory,
      ticketCount: selectedTicketCount,
    );

    return repository.createOrder(
      visitorName: name,
      visitDate: date,
      visitTime: time,
      category: selectedCategory,
      ticketCount: selectedTicketCount,
      pricePerTicket: pricePerTicket,
      totalPrice: totalPrice,
      location: defaults.location,
    );
  }
}
