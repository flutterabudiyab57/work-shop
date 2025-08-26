// oil_state.dart

import '../model/oil_model.dart';

abstract class OilState {}

class OilInitial extends OilState {}
class OilLoading extends OilState {}
class OilLoaded extends OilState {
  final List<Oil> oils;
  OilLoaded(this.oils);
}
class OilError extends OilState {
  final String message;
  OilError(this.message);
}
