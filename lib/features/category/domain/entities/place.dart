class Place {
  final String id;
  final String title;
  final String categoryKey;
  final String categoryName;
  final String description;
  final String imagePath;
  final bool isNetwork;
  final double initialRating;
  final String operationalHours;
  final List<String> images;
  final List<String> galleryImages;
  final double? latitude;
  final double? longitude;
  final int? pinColor;
  final String? markerIconKey;

  const Place({
    required this.id,
    required this.title,
    required this.categoryKey,
    required this.categoryName,
    required this.description,
    required this.imagePath,
    required this.initialRating,
    required this.operationalHours,
    required this.images,
    required this.galleryImages,
    this.isNetwork = false,
    this.latitude,
    this.longitude,
    this.pinColor,
    this.markerIconKey,
  });
}
