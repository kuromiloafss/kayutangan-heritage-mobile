import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/entities/user.dart';

class AuthRemoteDataSource {
  // Alamat backend Node.js
  final String baseUrl = 'http://localhost:3000/api/auth';

  // ======================================
  // REGISTER
  // ======================================

  Future<User> registerUser({
    required String nama,
    required String email,
    required String telepon,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/register');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'nama': nama,
          'email': email,
          'no_hp': telepon,
          'password': password,
        }),
      );

      print('REGISTER STATUS: ${response.statusCode}');
      print('REGISTER RESPONSE: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 &&
          data['success'] == true) {
        return User.fromJson(data['data']);
      }

      throw Exception(
        data['message'] ?? 'Registrasi gagal.',
      );
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }

      throw Exception(
        'Tidak dapat menghubungi backend: $e',
      );
    }
  }

  // ======================================
  // LOGIN
  // ======================================

  Future<User> loginUser({
    required String identifier,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'identifier': identifier,
          'password': password,
        }),
      );

      print('LOGIN STATUS: ${response.statusCode}');
      print('LOGIN RESPONSE: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data['success'] == true) {
        return User.fromJson(data['data']);
      }

      throw Exception(
        data['message'] ?? 'Login gagal.',
      );
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }

      throw Exception(
        'Tidak dapat menghubungi backend: $e',
      );
    }
  }
}