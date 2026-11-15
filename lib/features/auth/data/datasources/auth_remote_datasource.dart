import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthRemoteDataSource {
  // PENTING: Sesuaikan URL ini.
  // - Jika run di Web / Windows: http://localhost:3000
  // - Jika run di Android Emulator: http://10.0.2.2:3000
  // - Jika run di HP Asli (OPPO): http://IP_WIFI_LAPTOP:3000
  final String baseUrl = 'http://localhost:3000/api/auth';

  Future<bool> registerUser(String nama, String email, String telepon, String password) async {
    final url = Uri.parse('$baseUrl/register');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nama_lengkap': nama,
          'email': email,
          'nomor_telepon': telepon,
          'kata_sandi': password,
        }),
      );

      print('Status API: ${response.statusCode}'); // Cek di terminal VS Code
      print('Balasan API: ${response.body}');

      if (response.statusCode == 201) {
        return true; // Sukses daftar
      } else {
        throw Exception(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      throw Exception('Gagal nyambung ke server: $e');
    }
  }
}