import 'package:equatable/equatable.dart';

class CheckoutUserError extends Equatable {
  const CheckoutUserError({
    required this.code,
    required this.fields,
    required this.message,
  });

  /// The error code.
  final String code;

  /// The path to the input field(s) that caused the error.
  final List<dynamic> fields;

  /// The error message.
  final String message;

  @override
  List<Object?> get props => [code, fields, message];

  @override
  bool get stringify => true;
}
