import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/CarModel.dart';
import 'CarModelState.dart';

class CarModelCubit extends Cubit<CarModelState> {
  final Dio dio;
  final String productionApi;

  CarModelCubit({
    required this.dio,
    required this.productionApi,
  }) : super(CarModelInitial());

  Future<void> fetchCarModels(int brandId) async {
    emit(CarModelLoading());

    try {
      final response = await dio.get(
        '$productionApi/car-brand/$brandId/models',
        options: Options(
          headers: {"Accept-Language": "ar"},
        ),
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        List<CarModel> models = (response.data['data'] as List)
            .map((json) => CarModel.fromJson(json))
            .toList();
        emit(CarModelLoaded(models));
      } else {
        emit(CarModelError('حدث خطأ في جلب الموديلات'));
      }
    } catch (e) {
      emit(CarModelError('حدث خطأ: $e'));
    }
  }
}
