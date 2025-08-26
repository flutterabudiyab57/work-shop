class TranslationModel {
  final int id;
  final int carBrandId;
  final String locale;
  final String name;

  TranslationModel({
    required this.id,
    required this.carBrandId,
    required this.locale,
    required this.name,
  });

  factory TranslationModel.fromJson(Map<String, dynamic> json) {
    return TranslationModel(
      id: json['id'] ?? 0,
      carBrandId: json['car_brand_id'] ?? 0,
      locale: json['locale'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class CarBrandModel {
  final int id;
  final String name;
  final String image;
  final List<TranslationModel> translations;

  CarBrandModel({
    required this.id,
    required this.name,
    required this.image,
    required this.translations,
  });

  factory CarBrandModel.fromJson(Map<String, dynamic> json, {String locale = "en"}) {
    List<TranslationModel> translations = [];
    if (json['translations'] != null && json['translations'] is List) {
      translations = (json['translations'] as List)
          .map((t) => TranslationModel.fromJson(t))
          .toList();
    }

    // اختيار الاسم بحسب اللغة
    String translatedName = json['name'] ?? '';
    for (var t in translations) {
      if (t.locale == locale && t.name.isNotEmpty) {
        translatedName = t.name;
        break;
      }
    }

    // ✅ معالجة رابط الصورة (لو الرابط جاهز http نستعمله كما هو)
    String icon = json['icon'] ?? '';
    String imagePath = icon.startsWith("http")
        ? icon
        : "https://devworkshop.abudiyabksa.com/storage/$icon";

    return CarBrandModel(
      id: json['id'] ?? 0,
      name: translatedName,
      image: imagePath.isNotEmpty ? imagePath : 'assets/images/default_car.png',
      translations: translations,
    );
  }
}
