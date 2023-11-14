import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'options_selection.g.dart';

@HiveType(typeId: 7)
class OptionsSelections extends Equatable {
  @HiveField(0)
  final Map<String, int> selectedOptions;

  @HiveField(1)
  final int quantity;

  const OptionsSelections({
    this.selectedOptions = const {},
    this.quantity = 1,
  });

  @override
  List<Object?> get props => [selectedOptions, quantity];

  @override
  bool get stringify => true;
}
