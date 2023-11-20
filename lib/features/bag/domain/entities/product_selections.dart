import 'package:equatable/equatable.dart';

class ProductSelections extends Equatable {
  final List<ProductSelection> selections;
  final int quantity;

  const ProductSelections({
    this.selections = const [],
    this.quantity = 1,
  });

  @override
  List<Object?> get props => [selections, quantity];
  @override
  bool get stringify => true;
}

class ProductSelection extends Equatable {
  final String title;
  final List<String> values;
  final String chosenValue;

  const ProductSelection({
    required this.title,
    required this.values,
    required this.chosenValue,
  });

  @override
  List<Object?> get props => [title, values, chosenValue];
  @override
  bool get stringify => true;
}
