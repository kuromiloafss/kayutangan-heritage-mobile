import 'package:flutter/foundation.dart';

import '../../domain/entities/order.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/entities/ticket_form_defaults.dart';
import '../../domain/usecases/ambil_default_pesanan.dart';
import '../../domain/usecases/ambil_tiket.dart';
import '../../domain/usecases/ambil_tiket_saya.dart';
import '../../domain/usecases/buat_pesanan.dart';
import '../../domain/usecases/proses_pembayaran.dart';
import '../../domain/usecases/tandai_tiket_digunakan.dart';

class TicketViewModel extends ChangeNotifier {
  final AmbilTiket _ambilTiket;
  final AmbilTiketSaya _ambilTiketSaya;
  final AmbilDefaultPesanan _ambilDefaultPesanan;
  final BuatPesanan _buatPesanan;
  final ProsesPembayaran _prosesPembayaran;
  final TandaiTiketDigunakan _tandaiTiketDigunakan;

  List<Ticket> tiketSaya = const [];
  Order? pesananSaatIni;
  Ticket? tiketDetail;
  String? pesanError;
  late final TicketFormDefaults formDefaults;
  int get waktuBatasPembayaran => ProsesPembayaran.paymentTimeoutSeconds;

  TicketViewModel({
    required AmbilTiket ambilTiket,
    required AmbilTiketSaya ambilTiketSaya,
    required AmbilDefaultPesanan ambilDefaultPesanan,
    required BuatPesanan buatPesanan,
    required ProsesPembayaran prosesPembayaran,
    required TandaiTiketDigunakan tandaiTiketDigunakan,
  }) : _ambilTiket = ambilTiket,
       _ambilTiketSaya = ambilTiketSaya,
       _ambilDefaultPesanan = ambilDefaultPesanan,
       _buatPesanan = buatPesanan,
       _prosesPembayaran = prosesPembayaran,
       _tandaiTiketDigunakan = tandaiTiketDigunakan {
    formDefaults = _ambilDefaultPesanan.execute();
    ambilDataTiketSaya();
  }

  Order? buatPesanan({
    required String visitorName,
    required String visitDate,
    required String visitTime,
    required String category,
    required int ticketCount,
  }) {
    pesanError = null;
    try {
      pesananSaatIni = _buatPesanan.execute(
        visitorName: visitorName,
        visitDate: visitDate,
        visitTime: visitTime,
        category: category,
        ticketCount: ticketCount,
      );
      notifyListeners();
      return pesananSaatIni;
    } on ArgumentError catch (error) {
      pesanError = error.message.toString();
    } on StateError catch (error) {
      pesanError = error.message;
    }
    notifyListeners();
    return null;
  }

  Ticket? prosesPembayaran({
    required String orderId,
    required int remainingSeconds,
  }) {
    pesanError = null;
    try {
      tiketDetail = _prosesPembayaran.execute(
        orderId: orderId,
        remainingSeconds: remainingSeconds,
      );
      pesananSaatIni = pesananSaatIni?.copyWith(isPaid: true);
      tiketSaya = _ambilTiketSaya.execute();
      notifyListeners();
      return tiketDetail;
    } on ArgumentError catch (error) {
      pesanError = error.message.toString();
    } on StateError catch (error) {
      pesanError = error.message;
    }
    notifyListeners();
    return null;
  }

  void ambilDataTiketSaya() {
    pesanError = null;
    try {
      tiketSaya = _ambilTiketSaya.execute();
    } on ArgumentError catch (error) {
      pesanError = error.message.toString();
    } on StateError catch (error) {
      pesanError = error.message;
    }
    notifyListeners();
  }

  Ticket? ambilDetailTiket(String ticketCode) {
    pesanError = null;
    try {
      tiketDetail = _ambilTiket.execute(ticketCode: ticketCode);
      notifyListeners();
      return tiketDetail;
    } on ArgumentError catch (error) {
      pesanError = error.message.toString();
    } on StateError catch (error) {
      pesanError = error.message;
    }
    notifyListeners();
    return null;
  }

  bool tandaiTiketDigunakan(String ticketCode) {
    pesanError = null;
    try {
      tiketDetail = _tandaiTiketDigunakan.execute(ticketCode: ticketCode);
      tiketSaya = _ambilTiketSaya.execute();
      notifyListeners();
      return true;
    } on ArgumentError catch (error) {
      pesanError = error.message.toString();
    } on StateError catch (error) {
      pesanError = error.message;
    }
    notifyListeners();
    return false;
  }
}
