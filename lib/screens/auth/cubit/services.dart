// lib/core/network/api_service.dart
import 'package:dio/dio.dart';

class ApiService {
  final Dio dio;

  ApiService({String? baseUrl})
      : dio = Dio(BaseOptions(
    baseUrl: baseUrl ?? "{{live}}", // حط اللينك الأساسي هنا
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<Response> post(String endpoint, {Map<String, dynamic>? data}) async {
    return await dio.post(endpoint, data: data);
  }
}
