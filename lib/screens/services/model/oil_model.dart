
class Oil {
  final int id;
  final String name;
  final String type;
  final String brand;
  final String country;
  final int available;
  final String price;
  final String? description;

  Oil({
    required this.id,
    required this.name,
    required this.type,
    required this.brand,
    required this.country,
    required this.available,
    required this.price,
    this.description,
  });

  factory Oil.fromJson(Map<String, dynamic> json) {
    return Oil(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      brand: json['brand'],
      country: json['country'],
      available: json['available'],
      price: json['price'],
      description: json['description'] == "null" ? null : json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'brand': brand,
      'country': country,
      'available': available,
      'price': price,
      'description': description,
    };
  }
}