import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/oil_repo.dart';
import 'oil_state.dart';

class OilCubit extends Cubit<OilState> {
  final OilRepository repository;

  OilCubit(this.repository) : super(OilInitial());

  Future<void> fetchOilsByModel(int modelId) async {
    try {
      emit(OilLoading());
      final oils = await repository.getOilsByModel(modelId);
      emit(OilLoaded(oils));
    } catch (e) {
      emit(OilError(e.toString()));
    }
  }
}
