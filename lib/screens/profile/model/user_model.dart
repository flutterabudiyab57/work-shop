class UserModel {
  final int id;
  final String name;
  final String phone;
  final bool isPhoneVerified;
  final String role;
  final String? address;
  final String createdAt;
  final String updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.isPhoneVerified,
    required this.role,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      isPhoneVerified: json['is_phone_verified'],
      role: json['role'],
      address: json['address'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
