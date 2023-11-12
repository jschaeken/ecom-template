part of 'options_selection_bloc.dart';

sealed class OptionsSelectionEvent extends Equatable {
  const OptionsSelectionEvent();

  @override
  List<Object> get props => [];
}

class GetSavedSelectedOptionsEvent extends OptionsSelectionEvent {
  final String productId;

  const GetSavedSelectedOptionsEvent({required this.productId});

  @override
  List<Object> get props => [productId];
}

class OptionsSelectionChanged extends OptionsSelectionEvent {
  // Single option selection
  final String optionName;
  final int indexValue;
  final String productId;

  const OptionsSelectionChanged({
    required this.optionName,
    required this.indexValue,
    required this.productId,
  });

  @override
  List<Object> get props => [optionName, indexValue, productId];
}
