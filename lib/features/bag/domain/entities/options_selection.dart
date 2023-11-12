import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'options_selection.g.dart';

@HiveType(typeId: 7)
class OptionsSelections extends Equatable {
  @HiveField(0)
  final Map<String, int> selectedOptions;

  const OptionsSelections({
    required this.selectedOptions,
  });

  @override
  List<Object?> get props => [selectedOptions];

  @override
  bool get stringify => true;
}
