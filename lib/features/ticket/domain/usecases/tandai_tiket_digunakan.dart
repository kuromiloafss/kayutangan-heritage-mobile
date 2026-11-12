import '../entities/ticket.dart';
import '../repositories/ticket_repository.dart';

class TandaiTiketDigunakan {
  final TicketRepository repository;

  const TandaiTiketDigunakan({required this.repository});

  Ticket execute({required String ticketCode}) {
    final code = ticketCode.trim();
    if (code.isEmpty) {
      throw ArgumentError('Kode tiket tidak boleh kosong.');
    }

    final ticket = repository.getTicketByCode(code);
    if (ticket == null) {
      throw StateError('Tiket tidak ditemukan.');
    }
    if (!ticket.isActive) {
      throw StateError('Tiket sudah digunakan.');
    }
    repository.markTicketUsed(code);
    final updatedTicket = repository.getTicketByCode(code);
    if (updatedTicket == null) {
      throw StateError('Tiket tidak ditemukan setelah diperbarui.');
    }
    return updatedTicket;
  }
}
