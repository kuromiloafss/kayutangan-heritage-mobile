import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/assets.dart';
import '../home/home_page.dart';
import 'ticket_detail_page.dart';

class TicketHistoryItem {
  final String title;
  final String timestamp;
  final String ticketCode;

  TicketHistoryItem({
    required this.title,
    required this.timestamp,
    required this.ticketCode,
  });
}

class MyTicketsPage extends StatefulWidget {
  final String activeDate;
  final String activeTime;
  final String location;
  final String ticketCode;
  final String visitorName;

  const MyTicketsPage({
    super.key,
    this.activeDate = '9 Sep 2026',
    this.activeTime = '10.35',
    this.location = 'Kayutangan Heritage',
    this.ticketCode = 'KH-20072210-13',
    this.visitorName = 'Budi Galaksi',
  });

  @override
  State<MyTicketsPage> createState() => _MyTicketsPageState();
}

class _MyTicketsPageState extends State<MyTicketsPage> {
  bool _hasActiveTicket = true;

  late List<TicketHistoryItem> _historyList;

  @override
  void initState() {
    super.initState();
    _historyList = [
      TicketHistoryItem(
        title: 'Kayutangan Heritage',
        timestamp: '1 Sep 2026 - 14.32 WIB',
        ticketCode: 'KH-19090114-08',
      ),
      TicketHistoryItem(
        title: 'Kayutangan Heritage',
        timestamp: '25 Okt 2026 - 18.38 WIB',
        ticketCode: 'KH-19102518-22',
      ),
    ];
  }

  // Pindahkan tiket aktif ke riwayat saat berhasil di-scan
  void _moveActiveTicketToHistory() {
    setState(() {
      _hasActiveTicket = false;
      _historyList.insert(
        0,
        TicketHistoryItem(
          title: widget.location,
          timestamp: '${widget.activeDate} - ${widget.activeTime} WIB',
          ticketCode: widget.ticketCode,
        ),
      );
    });
  }

  void _openDetailTicket({required bool isActive, required String code}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicketDetailPage(
          ticketCode: code,
          visitorName: widget.visitorName,
          visitDate: widget.activeDate,
          visitTime: widget.activeTime,
          location: widget.location,
          isActive: isActive,
          onTicketScanned: isActive ? _moveActiveTicketToHistory : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2E2E2E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tiket Saya',
          style: TextStyle(
            color: Color(0xFF2E2E2E),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          // 1. Watermark pattern rumah heritage
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.85,
                child: Image.asset(
                  AppAssets.pattern,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),

          // 2. Konten Utama
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TIKET AKTIF (Jika masih ada)
                  if (_hasActiveTicket) ...[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Header Hijau
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                            decoration: const BoxDecoration(
                              color: Color(0xFF334227),
                              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.confirmation_num_outlined,
                                    color: Color(0xFF334227),
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Akses Tiket Wisata',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Kampoeng Heritage Kayutangan',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // QR dan Rincian
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(22)),
                              border: Border.all(color: const Color(0xFFEEEEEE)),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(color: const Color(0xFFE2E2E2)),
                                      ),
                                      child: const Icon(
                                        Icons.qr_code_2_rounded,
                                        size: 88,
                                        color: Color(0xFF222222),
                                      ),
                                    ),
                                    const SizedBox(width: 18),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          _buildTicketInfoItem(
                                            Icons.calendar_today_outlined,
                                            widget.activeDate,
                                          ),
                                          const SizedBox(height: 10),
                                          _buildTicketInfoItem(
                                            Icons.access_time_rounded,
                                            widget.activeTime,
                                          ),
                                          const SizedBox(height: 10),
                                          _buildTicketInfoItem(
                                            Icons.location_on_outlined,
                                            widget.location,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 18),

                                // Tombol Buka Detail Tiket
                                SizedBox(
                                  width: double.infinity,
                                  height: 44,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    onPressed: () => _openDetailTicket(
                                      isActive: true,
                                      code: widget.ticketCode,
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.confirmation_num_outlined, color: Colors.white, size: 18),
                                        SizedBox(width: 8),
                                        Text(
                                          'Lihat Detail Tiket',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Icon(Icons.chevron_right_rounded, color: Colors.white, size: 18),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                  ] else ...[
                    // Info jika tidak ada tiket aktif
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFEEEEEE)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, color: Color(0xFF888888)),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Tidak ada tiket aktif saat ini. Tiket yang sudah di-scan telah dipindahkan ke riwayat.',
                              style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // RIWAYAT TIKET
                  const Text(
                    'Riwayat Tiket',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // List Item Riwayat
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _historyList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = _historyList[index];
                      return _buildHistoryCard(
                        title: item.title,
                        timestamp: item.timestamp,
                        onTap: () => _openDetailTicket(
                          isActive: false,
                          code: item.ticketCode,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 48),

                  // Tombol Kembali Beranda
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePage()),
                          (route) => false,
                        );
                      },
                      child: const Text(
                        'Kembali Beranda',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF555555)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryCard({
    required String title,
    required String timestamp,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: Color(0xFFECECEC),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.confirmation_num_outlined,
            color: Color(0xFF555555),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF222222),
          ),
        ),
        subtitle: Text(
          timestamp,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF888888),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Color(0xFF888888),
          size: 22,
        ),
      ),
    );
  }
}