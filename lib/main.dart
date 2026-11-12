import 'package:flutter/material.dart';
import 'core/localization/app_language.dart';
import 'features/auth/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Saat bahasa berubah, seluruh widget di dalam aplikasi otomatis ter-rebuild dengan bahasa baru
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.currentLocale,
      builder: (context, locale, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Kayutangan Heritage',
          theme: ThemeData(
            fontFamily: 'Poppins',
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF334227)),
            useMaterial3: true,
          ),
          home: const WelcomePage(),
        );
      },
    );
  }
}