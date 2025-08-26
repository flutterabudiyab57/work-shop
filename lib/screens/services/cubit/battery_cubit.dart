import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/battery_repo.dart';
import '../repo/oil_repo.dart';
import 'battery_state.dart';
import 'oil_state.dart';

class BatteryCubit extends Cubit<BatteryState> {
  final BatteryRepository repository;

  BatteryCubit(this.repository) : super(BatteryInitial());

  Future<void> fetchBatterysByModel(int modelId) async {
    try {
      emit(BatteryLoading());
      final batterys = await repository.getBatterysByModel(modelId);
      emit(BatteryLoaded(batterys));
    } catch (e) {
      emit(BatteryError(e.toString()));
    }
  }
}
