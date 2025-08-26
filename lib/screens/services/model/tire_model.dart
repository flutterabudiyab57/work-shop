
class Tire {
  final int id;
  final String size;
  final int price;
  final String manufactureYear;
  final int available;
  final String type;
  final String brand;
  final String country;

  Tire({
    required this.id,
    required this.size,
    required this.price,
    required this.manufactureYear,
    required this.available,
    required this.type,
    required this.brand,
    required this.country,
  });

  factory Tire.fromJson(Map<String, dynamic> json) {
    return Tire(
      id: json['id'] ?? 0,
      size: json['size'] ?? '',
      price: json['price'] ?? 0,
      manufactureYear: json['manufacture_year'] ?? '',
      available: json['available'] ?? 0,
      type: json['type'] ?? '',
      brand: json['brand'] ?? '',
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'size': size,
      'price': price,
      'manufacture_year': manufactureYear,
      'available': available,
      'type': type,
      'brand': brand,
      'country': country,
    };
  }
}