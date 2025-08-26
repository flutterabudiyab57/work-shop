import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositorie/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;

  ProfileCubit(this.repository) : super(ProfileInitial());

  void fetchProfile() async {
    emit(ProfileLoading());
    try {
      final user = await repository.getUserProfile();
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError('لم يتم العثور على البيانات'));
      }
    } catch (e) {
      emit(ProfileError('فشل تحميل البيانات'));
    }
  }
}
