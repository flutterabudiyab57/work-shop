import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:dio/dio.dart';
import '../model/oil_model.dart';
import '../model/tire_model.dart';

class TireRepository {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        "Accept": "application/json",
        "Accept-Language": "ar",

      },
    ),
  );

  Future<List<Tire>> getTiresByModel(int modelId) async {
    try {
      final response = await _dio.get("$mainApi/car-models/$modelId/tires");
      print(response.data);
      print(modelId);

      if (response.statusCode == 200) {
        final body = response.data;

        if (body is Map && body['data'] is List) {
          final data = body['data'] as List;
          return data.map((e) => Tire.fromJson(e)).toList();
        } else {
          throw Exception("Unexpected response format: $body");
        }
      } else {
        throw Exception("Failed with status ${response.statusCode}");
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.data ?? e.message}");
      throw Exception("Dio error: ${e.message}");
    } catch (e) {
      print("Unexpected error: $e");
      throw Exception("Unexpected error: $e");
    }
  }
}
