class Battery {
  final int id;
  final String serialCode;
  final String type;
  final String brand;
  final String country;
  final String manufactureYear;
  final int ampere;
  final String price;
  final String warranty;
  final String warrantyUnit;
  final int available;

  Battery({
    required this.id,
    required this.serialCode,
    required this.type,
    required this.brand,
    required this.country,
    required this.manufactureYear,
    required this.ampere,
    required this.price,
    required this.warranty,
    required this.warrantyUnit,
    required this.available,
  });

  factory Battery.fromJson(Map<String, dynamic> json) {
    return Battery(
      id: json['id'] ?? 0,
      serialCode: json['serial_code'] ?? '',
      type: json['type'] ?? '',
      brand: json['brand'] ?? '',
      country: json['country'] ?? '',
      manufactureYear: json['manufacture_year'] ?? '',
      ampere: json['ampere'] ?? 0,
      price: json['price'] ?? '0.00',
      warranty: json['warranty'] ?? '0.00',
      warrantyUnit: json['warranty_unit'] ?? '',
      available: json['available'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serial_code': serialCode,
      'type': type,
      'brand': brand,
      'country': country,
      'manufacture_year': manufactureYear,
      'ampere': ampere,
      'price': price,
      'warranty': warranty,
      'warranty_unit': warrantyUnit,
      'available': available,
    };
  }
}