
import '../model/car_brand_model.dart';

abstract class CarBrandState  {
  @override
  List<Object?> get props => [];
}

class CarBrandInitial extends CarBrandState {}

class CarBrandLoading extends CarBrandState {}

class CarBrandLoaded extends CarBrandState {
  final List<CarBrandModel> brands;

  CarBrandLoaded(this.brands);

  @override
  List<Object?> get props => [brands];
}

class CarBrandError extends CarBrandState {
  final String message;

  CarBrandError(this.message);

  @override
  List<Object?> get props => [message];
}
