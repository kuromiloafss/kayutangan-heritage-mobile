import '../entities/ticket_form_defaults.dart';
import '../repositories/ticket_repository.dart';

class AmbilDefaultPesanan {
  final TicketRepository repository;

  const AmbilDefaultPesanan({required this.repository});

  TicketFormDefaults execute() => repository.getFormDefaults();
}
