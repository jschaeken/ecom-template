part of 'options_selection_bloc.dart';

sealed class OptionsSelectionEvent extends Equatable {
  const OptionsSelectionEvent();

  @override
  List<Object> get props => [];
}

class OptionsSelectionStarted extends OptionsSelectionEvent {
  const OptionsSelectionStarted();

  @override
  List<Object> get props => [];
}

class OptionsSelectionChanged extends OptionsSelectionEvent {
  // Single option selection
  final String optionName;
  final int indexValue;
  final ShopProduct product;

  const OptionsSelectionChanged({
    required this.optionName,
    required this.indexValue,
    required this.product,
  });

  @override
  List<Object> get props => [optionName, indexValue, product];
}

class OptionsSelectionQuantityChanged extends OptionsSelectionEvent {
  final int quantity;

  final ShopProduct product;
  const OptionsSelectionQuantityChanged(
      {required this.quantity, required this.product});

  @override
  List<Object> get props => [quantity, product];
}

class CheckValidOptionsSelectionEvent extends OptionsSelectionEvent {
  final ShopProduct product;

  const CheckValidOptionsSelectionEvent({required this.product});

  @override
  List<Object> get props => [product];
}

class PushOptionsSelectionErrorState extends OptionsSelectionEvent {
  final IncompleteOptionsSelectionFailure failure;

  const PushOptionsSelectionErrorState({required this.failure});

  @override
  List<Object> get props => [failure];
}
