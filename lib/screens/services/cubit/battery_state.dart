// oil_state.dart


import 'package:abu_diyab_workshop/screens/services/model/battery_model.dart';

abstract class BatteryState {}

class BatteryInitial extends BatteryState {}
class BatteryLoading extends BatteryState {}
class BatteryLoaded extends BatteryState {
  final List<Battery> batterys;
  BatteryLoaded(this.batterys);
}
class BatteryError extends BatteryState {
  final String message;
  BatteryError(this.message);
}
