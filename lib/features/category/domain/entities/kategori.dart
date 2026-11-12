class Kategori {
  final String id;
  final String title;
  final String emoji;
  final bool tampilDiBeranda;

  const Kategori({
    required this.id,
    required this.title,
    required this.emoji,
    this.tampilDiBeranda = true,
  });
}
