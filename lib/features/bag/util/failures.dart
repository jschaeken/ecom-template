import 'package:ecom_template/core/error/failures.dart';

class IncompleteOptionsSelectionFailure extends Failure {
  final String message;

  const IncompleteOptionsSelectionFailure(
      {this.message = 'Please complete all required options'});

  @override
  List<Object> get props => [message];
}
