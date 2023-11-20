import 'package:ecom_template/core/error/failures.dart';

class IncompleteOptionsSelectionFailure extends Failure {
  final String message;

  const IncompleteOptionsSelectionFailure({required this.message});

  @override
  List<Object> get props => [message];
}
