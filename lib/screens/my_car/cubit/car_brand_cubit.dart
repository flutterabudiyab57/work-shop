import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../model/car_brand_model.dart';
import 'car_brand_state.dart';

class CarBrandCubit extends Cubit<CarBrandState> {
  final Dio dio;
  final String productionApi;
  final String brandApi;

  CarBrandCubit({
    required this.dio,
    required this.productionApi,
    required this.brandApi,
  }) : super(CarBrandInitial());

  Future<void> fetchCarBrands({String locale = 'ar'}) async {
    emit(CarBrandLoading());

    try {
      final response = await dio.get(
        productionApi + brandApi,
        options: Options(headers: {'Accept-Language': locale}),
      );

      if (response.statusCode == 200) {
        /// بعض الـ APIs بيرجع List مباشرة أو Map فيه key اسمه "data"
        final List data = response.data is List ? response.data : response.data['data'];

        final brands = data
            .map((e) => CarBrandModel.fromJson(e, locale: locale))
            .toList();

        emit(CarBrandLoaded(brands));
      } else {
        emit(CarBrandError('Failed to load car brands'));
      }
    } catch (e) {
      emit(CarBrandError('Error: $e'));
    }
  }
}
