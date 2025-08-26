class ServiceModel {
  final int id;
  final String title;
  final String description;
  final String image;
  final int active;
  final String createdAt;
  final String updatedAt;

  ServiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? 0,
      title: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['icon'] ?? '',
      active: json['active'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
