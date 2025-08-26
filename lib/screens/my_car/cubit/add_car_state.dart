
abstract class AddCarState   {
  @override
  List<Object?> get props => [];
}

class AddCarInitial extends AddCarState {}

class AddCarLoading extends AddCarState {}

class AddCarSuccess extends AddCarState {
  final String message;

  AddCarSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AddCarError extends AddCarState {
  final String message;

  AddCarError(this.message);

  @override
  List<Object?> get props => [message];
}
