// ignore_for_file: constant_identifier_names

import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure({this.message = ''});

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {}

class InternetConnectionFailure extends Failure {}

class CacheFailure extends Failure {}

class UnknownFailure extends Failure {}

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String INTERNET_CONNECTION_FAILURE_MESSAGE =
    'Internet Connection Failure';
const String UNEXPECTED_FAILURE_MESSAGE = 'Unexpected Error';

String mapFailureToErrorMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE;
    case InternetConnectionFailure:
      return INTERNET_CONNECTION_FAILURE_MESSAGE;
    default:
      return UNEXPECTED_FAILURE_MESSAGE;
  }
}

class DiscountCodeFailure extends Failure {
  const DiscountCodeFailure({required String message})
      : super(message: message);
}
