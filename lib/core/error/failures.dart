import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {}

class InternetConnectionFailure extends Failure {}

class UnknownFailure extends Failure {}
