import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String errorMessage;

  const Failure([this.errorMessage = 'Unexpected Error']);

  @override
  List<Object> get props => [errorMessage];
}