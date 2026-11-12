import '../entities/order.dart';
import '../entities/ticket.dart';
import '../entities/ticket_form_defaults.dart';

abstract class TicketRepository {
  TicketFormDefaults getFormDefaults();

  int getPricePerTicket(String category);

  Order createOrder({
    required String visitorName,
    required String visitDate,
    required String visitTime,
    required String category,
    required int ticketCount,
    required int pricePerTicket,
    required int totalPrice,
    required String location,
  });

  Order? getOrderById(String orderId);

  void markOrderPaid(String orderId);

  String createTicketCode();

  void saveTicket(Ticket ticket);

  List<Ticket> getMyTickets();

  Ticket? getTicketByCode(String ticketCode);

  void markTicketUsed(String ticketCode);
}
