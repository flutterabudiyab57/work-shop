import 'dart:io';
import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'add_car_state.dart';

class AddCarCubit extends Cubit<AddCarState> {
  AddCarCubit() : super(AddCarInitial());

  Dio dio = Dio();

  Future<void> addCar({
    required int userId,
    required File? carDocs, // 👈 خليها File? بدل String
    required int kiloRead,
    required String translationName,
    required String boardNo,
    required String creationYear,
    required int carModelId,
    required int carBrandId,
    required String token,
  }) async {
    emit(AddCarLoading());

    try {
      FormData formData = FormData.fromMap({
        "user_id": userId,
        "kilo_read": kiloRead,
        "translations[0][name]": translationName,
        "translations[0][locale]": "ar", // 👈 أضف اللغة
        "board_no": boardNo,
        "creation_year": creationYear,
        "car_model_id": carModelId,
        "car_brand_id": carBrandId,
        if (carDocs != null)
          "car_docs": await MultipartFile.fromFile(
            carDocs.path,
            filename: carDocs.path.split("/").last,
          ),
      });

      debugPrint("📤 Sending fields: ${formData.fields}");
      debugPrint("📤 Sending files: ${formData.files}");

      final response = await dio.post(
        "$productionApi/user-cars",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
        data: formData,
      );

      debugPrint("📥 Response: ${response.statusCode}");
      debugPrint("📥 Response data: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(AddCarSuccess(response.data["message"] ?? "Car added successfully ✅"));
      } else {
        emit(AddCarError("❌ Failed: ${response.statusCode} - ${response.statusMessage}"));
      }
    } catch (e, stack) {
      if (e is DioException && e.response != null) {
        debugPrint("🔥 Dio error data: ${e.response?.data}");
      }
      debugPrint("🔥 Error in AddCarCubit: $e");
      debugPrint(stack.toString());
      emit(AddCarError("Error: $e"));
    }

  }
}
