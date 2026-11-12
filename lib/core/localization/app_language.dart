import 'package:flutter/material.dart';

class AppLanguage {
  // Notifier global untuk memantau bahasa yang aktif ('id' atau 'en')
  static final ValueNotifier<String> currentLocale = ValueNotifier<String>('id');

  // Helper untuk mengecek apakah sedang mode Indonesia
  static bool get isIndonesian => currentLocale.value == 'id';

  // Fungsi mengubah bahasa secara realtime di seluruh aplikasi
  static void changeLanguage(String langCode) {
    if (currentLocale.value != langCode) {
      currentLocale.value = langCode;
    }
  }

  // Kamus Kata / Terjemahan
  static final Map<String, Map<String, String>> _localizedValues = {
    'id': {
      'welcome_title': 'Selamat Datang',
      'welcome_subtitle': 'Jelajahi keindahan sejarah dan budaya di Kampoeng Heritage Kayutangan Malang.',
      'login': 'Masuk',
      'register': 'Daftar',
      'email': 'Email',
      'password': 'Kata Sandi',
      'forgot_password': 'Lupa Kata Sandi?',
      'select_language': 'Pilih Bahasa',
      'home': 'Beranda',
      'ticket': 'Tiket',
      'tour_map': 'Peta Wisata',
      'account': 'Akun Anda',
      'ask_ai': 'Tanya AI',
      'you_are_here': 'Anda di sini',
      'search_place_hint': 'Cari lokasi atau tempat...',
      'all': 'Semua',
      'photo_spot': 'Spot Foto',
      'culinary': 'Kuliner',
      'cafe': 'Cafe',
      'souvenir': 'Cinderamata',
      'history': 'Sejarah',
      'toilet': 'Toilet',
      'mosque': 'Mesjid',
      'lodging': 'Penginapan',
      'my_tickets': 'Tiket Saya',
      'active_ticket': 'Tiket Aktif',
      'ticket_history': 'Riwayat Tiket',
      'settings': 'Pengaturan',
      'logout': 'Keluar',
      'save_changes': 'Simpan Perubahan',
    },
    'en': {
      'welcome_title': 'Welcome',
      'welcome_subtitle': 'Explore the historical beauty and culture at Kampoeng Heritage Kayutangan Malang.',
      'login': 'Login',
      'register': 'Register',
      'email': 'Email',
      'password': 'Password',
      'forgot_password': 'Forgot Password?',
      'select_language': 'Select Language',
      'home': 'Home',
      'ticket': 'Tickets',
      'tour_map': 'Tour Map',
      'account': 'My Account',
      'ask_ai': 'Ask AI',
      'you_are_here': 'You are here',
      'search_place_hint': 'Search locations or places...',
      'all': 'All',
      'photo_spot': 'Photo Spot',
      'culinary': 'Culinary',
      'cafe': 'Cafe',
      'souvenir': 'Souvenirs',
      'history': 'History',
      'toilet': 'Restroom',
      'mosque': 'Mosque',
      'lodging': 'Lodging',
      'my_tickets': 'My Tickets',
      'active_ticket': 'Active Ticket',
      'ticket_history': 'Ticket History',
      'settings': 'Settings',
      'logout': 'Logout',
      'save_changes': 'Save Changes',
    },
  };

  // Fungsi praktis memanggil teks: AppLanguage.tr('key')
  static String tr(String key) {
    return _localizedValues[currentLocale.value]?[key] ?? key;
  }
}