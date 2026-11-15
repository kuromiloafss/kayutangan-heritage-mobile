import 'package:flutter/material.dart';

// Fallback in case the real datasource class is not available yet.
// Replace this with your actual datasource implementation when it's ready.
class AuthRemoteDataSource {
  Future<bool> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return email.isNotEmpty && password.isNotEmpty;
  }
}

// TODO: Import halaman beranda kamu di sini untuk navigasi setelah sukses login
// import 'package:kayutangan_heritage/features/home/presentation/pages/beranda_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller untuk mengambil teks yang diketik user
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  // Variabel untuk mengecek apakah sedang proses loading nembak API
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email atau nomor telepon'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            
            // TOMBOL LOGIN
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : () async {
                  // 1. Ambil teks dari controller
                  final String email = emailController.text.trim();
                  final String password = passwordController.text.trim();
                  
                  // 2. Validasi input kosong
                  if (email.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email dan password harus diisi.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  // 3. Ubah state jadi loading
                  setState(() {
                    _isLoading = true;
                  });

                  // 4. Panggil API Login
                  try {
                    bool isSuccess = await AuthRemoteDataSource().loginUser(email, password);
                    
                    if (isSuccess) {
                      if (!mounted) return; // Mencegah error jika widget sudah ditutup
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Login Berhasil!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      
                      // 5. Navigasi ke Halaman Beranda (hapus komentar kode di bawah jika halaman beranda sudah ada)
                      /*
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => BerandaPage()),
                      );
                      */
                    }
                  } catch (e) {
                    if (!mounted) return;
                    // Tampilkan pesan error dari backend (misal: "Password salah!" atau "Email tidak ditemukan!")
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString().replaceAll('Exception: ', '')),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } finally {
                    // Matikan efek loading
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  }
                },
                child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}