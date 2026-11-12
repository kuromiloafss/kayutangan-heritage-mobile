class Profile {
  final String name;
  final String email;
  final String phone;
  final String birthDate;
  final String domicile;
  final String nameFallback;

  const Profile({
    required this.name,
    required this.email,
    required this.phone,
    required this.birthDate,
    required this.domicile,
    required this.nameFallback,
  });

  String get displayName => name.isEmpty ? nameFallback : name;
}
