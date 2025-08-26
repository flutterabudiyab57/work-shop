import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';

class ProfileRepository {
  final Dio _dio = Dio();

  Future<UserModel?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return null;

    try {
      final response = await _dio.get(
        mainApi+profileApi,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        }),
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['data']);
      }
    } catch (e) {
      throw Exception('Error fetching profile: $e');
    }

    return null;
  }
}
