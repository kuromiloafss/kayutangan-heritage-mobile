import 'package:flutter_test/flutter_test.dart';
import 'package:kayutangan_heritage/features/ticket/data/repositories/ticket_repository_memory.dart';
import 'package:kayutangan_heritage/features/ticket/domain/usecases/ambil_tiket.dart';
import 'package:kayutangan_heritage/features/ticket/domain/usecases/ambil_tiket_saya.dart';
import 'package:kayutangan_heritage/features/ticket/domain/usecases/buat_pesanan.dart';
import 'package:kayutangan_heritage/features/ticket/domain/usecases/hitung_total.dart';
import 'package:kayutangan_heritage/features/ticket/domain/usecases/proses_pembayaran.dart';
import 'package:kayutangan_heritage/features/ticket/domain/usecases/tandai_tiket_digunakan.dart';

void main() {
  test(
    'order creation applies repository defaults and calculates category price',
    () {
      final repository = TicketRepositoryMemory();
      final createOrder = BuatPesanan(
        repository: repository,
        hitungTotal: HitungTotal(repository: repository),
      );

      final order = createOrder.execute(
        visitorName: '',
        visitDate: '',
        visitTime: '',
        category: 'Turis',
        ticketCount: 2,
      );

      expect(order.visitorName, 'Budi Galaksi');
      expect(order.visitDate, '9 September 2026');
      expect(order.pricePerTicket, 10000);
      expect(order.totalPrice, 20000);
      expect(
        () => createOrder.execute(
          visitorName: '',
          visitDate: '',
          visitTime: '',
          category: 'Lokal',
          ticketCount: 0,
        ),
        throwsArgumentError,
      );
    },
  );

  test('payment creates a shared active ticket that can be scanned once', () {
    final repository = TicketRepositoryMemory();
    final order =
        BuatPesanan(
          repository: repository,
          hitungTotal: HitungTotal(repository: repository),
        ).execute(
          visitorName: 'Nina',
          visitDate: '2 Desember 2026',
          visitTime: '11.20',
          category: 'Lokal',
          ticketCount: 1,
        );
    final hitungTotal = HitungTotal(repository: repository);
    final processPayment = ProsesPembayaran(
      repository: repository,
      hitungTotal: hitungTotal,
    );
    expect(
      () => processPayment.execute(orderId: order.id, remainingSeconds: 0),
      throwsStateError,
    );
    final ticket = processPayment.execute(
      orderId: order.id,
      remainingSeconds: 600,
    );

    expect(
      AmbilTiket(repository: repository).execute(ticketCode: ticket.ticketCode),
      ticket,
    );
    expect(
      AmbilTiketSaya(repository: repository)
          .execute()
          .firstWhere((item) => item.ticketCode == ticket.ticketCode)
          .isActive,
      isTrue,
    );
    expect(
      () => processPayment.execute(orderId: order.id, remainingSeconds: 600),
      throwsStateError,
    );

    final scanned = TandaiTiketDigunakan(repository: repository)
        .execute(ticketCode: ticket.ticketCode);
    expect(scanned.isActive, isFalse);
    expect(scanned.historyTimestamp, '2 Desember 2026 - 11.20 WIB');
    expect(
      () =>
          TandaiTiketDigunakan(repository: repository)
              .execute(ticketCode: ticket.ticketCode),
      throwsStateError,
    );
  });
}
