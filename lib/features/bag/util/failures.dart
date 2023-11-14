import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/features/bag/domain/entities/options_selection.dart';

class IncompleteOptionsSelectionFailure extends Failure {
  final OptionsSelections currentSelectedOptions;
  final String? message;

  const IncompleteOptionsSelectionFailure(
      {this.currentSelectedOptions =
          const OptionsSelections(selectedOptions: {}),
      this.message});

  @override
  List<Object> get props => [currentSelectedOptions];
}
