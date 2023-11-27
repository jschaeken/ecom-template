// ignore_for_file: constant_identifier_names

import 'package:ecom_template/features/checkout/domain/entities/checkout_user_error.dart';
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

class CheckoutUserFailure extends Failure {
  final List<CheckoutUserError> userErrors;
  const CheckoutUserFailure({required this.userErrors});
}

class AuthFailure extends Failure {
  @override
  final String message;
  const AuthFailure({this.message = 'You must be logged in to do this'});
}
