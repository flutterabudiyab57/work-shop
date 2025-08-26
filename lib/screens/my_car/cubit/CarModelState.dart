import '../model/CarModel.dart';

abstract class CarModelState {}

class CarModelInitial extends CarModelState {}

class CarModelLoading extends CarModelState {}

class CarModelLoaded extends CarModelState {
  final List<CarModel> models;

  CarModelLoaded(this.models);
}

class CarModelError extends CarModelState {
  final String message;

  CarModelError(this.message);
}
