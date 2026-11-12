import '../entities/ticket.dart';
import '../repositories/ticket_repository.dart';

class AmbilTiket {
  final TicketRepository repository;

  const AmbilTiket({required this.repository});

  Ticket execute({required String ticketCode}) {
    final code = ticketCode.trim();
    if (code.isEmpty) {
      throw ArgumentError('Kode tiket tidak boleh kosong.');
    }

    final ticket = repository.getTicketByCode(code);
    if (ticket == null) {
      throw StateError('Tiket tidak ditemukan.');
    }
    return ticket;
  }
}
