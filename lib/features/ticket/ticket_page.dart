import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/assets.dart';
import 'order_summary_page.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({super.key});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  // Kategori pengunjung: 'Lokal' atau 'Turis'
  String _selectedCategory = 'Lokal';

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  // Buka Dialog Pemilih Tanggal
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text =
            "${pickedDate.day} ${_getMonthName(pickedDate.month)} ${pickedDate.year}";
      });
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return months[month - 1];
  }

  // Buka Dialog Pemilih Waktu
  Future<void> _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        final hour = pickedTime.hour.toString().padLeft(2, '0');
        final minute = pickedTime.minute.toString().padLeft(2, '0');
        _timeController.text = "$hour.$minute";
      });
    }
  }

  // Kirim data ke OrderSummaryPage dengan harga baru
  void _handlePayment() {
    final name = _nameController.text.trim();
    final date = _dateController.text.trim();
    final time = _timeController.text.trim();

    // Penentuan harga: Lokal 5.000, Turis 10.000
    final price = _selectedCategory == 'Lokal' ? 5000 : 10000;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderSummaryPage(
          visitorName: name.isNotEmpty ? name : 'Budi Galaksi',
          visitDate: date.isNotEmpty ? date : '9 September 2026',
          visitTime: time.isNotEmpty ? time : '10.35',
          category: _selectedCategory,
          ticketCount: 1,
          pricePerTicket: price,
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
        title: const Text(
          'Beli Tiket',
          style: TextStyle(
            color: Color(0xFF1E1E1E),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          // 1. Watermark pattern rumah bawah
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

          // 2. Formulir Konten Beli Tiket
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Banner Header Akses Tiket Wisata
                  Container(
                    height: 110,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=800&auto=format&fit=crop',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.75),
                            Colors.black.withOpacity(0.2),
                          ],
                        ),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Akses Tiket Wisata',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Kampoeng Heritage Kayutangan',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Card Form Data Pengunjung
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Data Pengunjung',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E2E2E),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Input Nama Lengkap
                        _buildFormRow(
                          icon: Icons.person_outline_rounded,
                          label: 'Nama Lengkap',
                          child: TextField(
                            controller: _nameController,
                            style: const TextStyle(fontSize: 13),
                            decoration: _fieldInputDecoration(),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Input Tanggal Kunjungan
                        _buildFormRow(
                          icon: Icons.calendar_today_outlined,
                          label: 'Tanggal Kunjungan',
                          child: InkWell(
                            onTap: _pickDate,
                            borderRadius: BorderRadius.circular(12),
                            child: IgnorePointer(
                              child: TextField(
                                controller: _dateController,
                                style: const TextStyle(fontSize: 13),
                                decoration: _fieldInputDecoration(),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Input Waktu Kunjungan
                        _buildFormRow(
                          icon: Icons.access_time_rounded,
                          label: 'Waktu Kunjungan',
                          child: InkWell(
                            onTap: _pickTime,
                            borderRadius: BorderRadius.circular(12),
                            child: IgnorePointer(
                              child: TextField(
                                controller: _timeController,
                                style: const TextStyle(fontSize: 13),
                                decoration: _fieldInputDecoration(),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Label Kategori Pengunjung
                        RichText(
                          text: const TextSpan(
                            text: 'Kategori Pengunjung ',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2E2E2E),
                            ),
                            children: [
                              TextSpan(
                                text: '*',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Toggle Buttons: Lokal vs Turis
                        Row(
                          children: [
                            // Tombol Lokal (5.000)
                            Expanded(
                              child: _buildCategoryButton(
                                label: 'Lokal',
                                icon: Icons.person_outline_rounded,
                                isSelected: _selectedCategory == 'Lokal',
                                onTap: () {
                                  setState(() {
                                    _selectedCategory = 'Lokal';
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Tombol Turis (10.000)
                            Expanded(
                              child: _buildCategoryButton(
                                label: 'Turis',
                                icon: Icons.language_rounded,
                                isSelected: _selectedCategory == 'Turis',
                                onTap: () {
                                  setState(() {
                                    _selectedCategory = 'Turis';
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tombol "Lanjutkan pembayaran ->"
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _handlePayment,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Lanjutkan pembayaran',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormRow({
    required IconData icon,
    required String label,
    required Widget child,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 28, color: const Color(0xFF3B3B3B)),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4A4A4A),
                  ),
                  children: const [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(height: 44, child: child),
            ],
          ),
        ),
      ],
    );
  }

  InputDecoration _fieldInputDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  Widget _buildCategoryButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF333333),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF333333),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}