import '../repositories/ticket_repository.dart';

class HitungTotal {
  final TicketRepository repository;

  const HitungTotal({required this.repository});

  int execute({required String category, required int ticketCount}) {
    if (ticketCount <= 0) {
      throw ArgumentError('Jumlah tiket harus lebih dari nol.');
    }

    final pricePerTicket = repository.getPricePerTicket(category);
    return pricePerTicket * ticketCount;
  }
}
