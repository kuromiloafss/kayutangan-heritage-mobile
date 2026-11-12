import '../entities/ticket.dart';
import '../repositories/ticket_repository.dart';

class AmbilTiketSaya {
  final TicketRepository repository;

  const AmbilTiketSaya({required this.repository});

  List<Ticket> execute() => repository.getMyTickets();
}
