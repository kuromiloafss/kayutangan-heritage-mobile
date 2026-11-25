class User {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String password;
  final String role;
  final String? avatarUrl;

  const User({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.password = '',
    this.role = 'user',
    this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),
      name: (json['nama'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phone: (json['no_hp'] ?? '').toString(),
      role: (json['role'] ?? 'user').toString(),
      avatarUrl: json['avatar_url']?.toString(),
    );
  }
}