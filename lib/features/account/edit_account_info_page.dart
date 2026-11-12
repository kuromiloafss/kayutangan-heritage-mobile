import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/assets.dart';

class EditAccountPage extends StatefulWidget {
  final String initialName;
  final String initialEmail;
  final String initialPhone;
  final String initialBirthDate;
  final String initialDomicile;

  const EditAccountPage({
    super.key,
    this.initialName = 'Budi',
    this.initialEmail = 'BudiKeren@gmail.com',
    this.initialPhone = '+62 812 0000 0000',
    this.initialBirthDate = '12 Juli 2000',
    this.initialDomicile = 'Malang',
  });

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _birthDateController;
  late TextEditingController _domicileController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _emailController = TextEditingController(text: widget.initialEmail);
    _phoneController = TextEditingController(text: widget.initialPhone);
    _birthDateController = TextEditingController(text: widget.initialBirthDate);
    _domicileController = TextEditingController(text: widget.initialDomicile);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _domicileController.dispose();
    super.dispose();
  }

  // Pemilih Tanggal Lahir
  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 7, 12),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
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

    if (picked != null) {
      const months = [
        'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
      ];
      setState(() {
        _birthDateController.text = "${picked.day} ${months[picked.month - 1]} ${picked.year}";
      });
    }
  }

  void _handleSave() {
    final updatedData = {
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      'birthDate': _birthDateController.text.trim(),
      'domicile': _domicileController.text.trim(),
    };

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Perubahan akun berhasil disimpan!'),
        backgroundColor: Color(0xFF334227),
      ),
    );

    Navigator.pop(context, updatedData);
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
          'Informasi Akun',
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

          // 2. Form Edit Akun
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 10.0),
              child: Column(
                children: [
                  // Kartu Profil Utama Mode Edit
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E3D22),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Avatar dengan Ikon Ubah Foto
                        Stack(
                          children: [
                            Container(
                              width: 66,
                              height: 66,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person_outline_rounded,
                                size: 40,
                                color: Color(0xFF2E3D22),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: InkWell(
                                onTap: () {
                                  debugPrint("Ubah avatar / upload foto");
                                },
                                child: Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: const Color(0xFF2E3D22), width: 1.5),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_outlined,
                                    size: 13,
                                    color: Color(0xFF2E3D22),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),

                        // Nama & Label "Ubah profil"
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _nameController.text.isNotEmpty ? _nameController.text : 'Budi',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Ubah profil',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Badge Akun Aktif
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.18),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '• ',
                                      style: TextStyle(
                                        color: Color(0xFF81C784),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                    Text(
                                      'Akun Aktif',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Kartu Form Input Field
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFEEEEEE)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildInputField(
                          icon: Icons.person_outline_rounded,
                          label: 'Nama Lengkap',
                          controller: _nameController,
                          onChanged: (val) => setState(() {}),
                        ),
                        _buildDivider(),

                        _buildInputField(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          controller: _emailController,
                        ),
                        _buildDivider(),

                        _buildInputField(
                          icon: Icons.phone_outlined,
                          label: 'Nomor Telepon',
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                        ),
                        _buildDivider(),

                        // Input Tanggal Lahir (Dengan Date Picker)
                        InkWell(
                          onTap: _pickBirthDate,
                          child: IgnorePointer(
                            child: _buildInputField(
                              icon: Icons.calendar_today_outlined,
                              label: 'Tanggal Lahir',
                              controller: _birthDateController,
                            ),
                          ),
                        ),
                        _buildDivider(),

                        _buildInputField(
                          icon: Icons.location_on_outlined,
                          label: 'Domisili',
                          controller: _domicileController,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Tombol "Simpan Perubahan"
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
                      onPressed: _handleSave,
                      child: const Text(
                        'Simpan Perubahan',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    void Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: const Color(0xFF444444)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF888888),
                  ),
                ),
                TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  onChanged: onChanged,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF222222),
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.0),
      child: Divider(height: 1, color: Color(0xFFF1F1F1)),
    );
  }
}