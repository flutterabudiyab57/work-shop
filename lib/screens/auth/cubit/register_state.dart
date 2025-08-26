abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final String message;
  final String? verificationSms;

  RegisterSuccess({required this.message, this.verificationSms});
}

class RegisterFailure extends RegisterState {
  final String error;

  RegisterFailure(this.error);
}
