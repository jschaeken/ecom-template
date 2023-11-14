part of 'options_selection_bloc.dart';

sealed class OptionsSelectionState extends Equatable {
  final OptionsSelections optionsSelection;

  const OptionsSelectionState({
    this.optionsSelection = const OptionsSelections(
      selectedOptions: {},
    ),
  });

  @override
  List<Object> get props => [optionsSelection];
}

final class OptionsSelectionInitial extends OptionsSelectionState {}

final class OptionsSelectionLoadingState extends OptionsSelectionState {
  const OptionsSelectionLoadingState();

  @override
  List<Object> get props => [];
}

final class OptionsSelectionLoadedCompleteState extends OptionsSelectionState {
  final BagItemData bagItemData;
  @override
  final OptionsSelections optionsSelection;

  const OptionsSelectionLoadedCompleteState({
    required this.bagItemData,
    required this.optionsSelection,
  }) : super(optionsSelection: optionsSelection);

  @override
  List<Object> get props => [bagItemData, optionsSelection];
}

final class OptionsSelectionLoadedIncompleteState
    extends OptionsSelectionState {
  const OptionsSelectionLoadedIncompleteState({
    required OptionsSelections optionsSelection,
  }) : super(optionsSelection: optionsSelection);

  @override
  List<Object> get props => [optionsSelection];
}

final class OptionsSelectionErrorState extends OptionsSelectionState {
  final IncompleteOptionsSelectionFailure failure;

  const OptionsSelectionErrorState({
    required this.failure,
  });

  @override
  List<Object> get props => [failure];
}
