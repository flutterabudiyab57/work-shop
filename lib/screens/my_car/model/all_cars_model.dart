class Car {
  final int id;
  final String boardNo;
  final String? name;
  final Map<String, dynamic> carBrand;
  final Map<String, dynamic> carModel;
  final int? creationYear;

  Car({
    required this.id,
    required this.boardNo,
    this.name,
    required this.carBrand,
    required this.carModel,
    this.creationYear,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      boardNo: json['board_no'] ?? '',
      name: json['name'],
      carBrand: json['car_brand'] ?? {},
      carModel: json['car_model'] ?? {},
      creationYear: json['creation_year'],
    );
  }
}
