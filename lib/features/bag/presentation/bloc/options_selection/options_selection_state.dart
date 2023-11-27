part of 'options_selection_bloc.dart';

sealed class OptionsSelectionState extends Equatable {
  final ProductSelections currentSelections;

  const OptionsSelectionState({
    this.currentSelections = const ProductSelections(),
  });

  @override
  List<Object> get props => [currentSelections];
}

final class OptionsSelectionInitial extends OptionsSelectionState {}

final class OptionsSelectionLoadingState extends OptionsSelectionState {
  const OptionsSelectionLoadingState();

  @override
  List<Object> get props => [];
}

final class OptionsSelectionLoadedCompleteState extends OptionsSelectionState {
  final BagItemData bagItemData;
  final bool isOutOfStock;

  const OptionsSelectionLoadedCompleteState({
    required this.bagItemData,
    required ProductSelections currentSelections,
    required this.isOutOfStock,
  }) : super(currentSelections: currentSelections);

  @override
  List<Object> get props => [bagItemData, currentSelections];
}

final class OptionsSelectionErrorState extends OptionsSelectionState {
  final IncompleteOptionsSelectionFailure failure;

  const OptionsSelectionErrorState({
    required this.failure,
    required ProductSelections currentSelections,
  }) : super(currentSelections: currentSelections);

  @override
  List<Object> get props => [failure, currentSelections];
}
