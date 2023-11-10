part of 'options_selection_bloc.dart';

sealed class OptionsSelectionState extends Equatable {
  const OptionsSelectionState();

  @override
  List<Object> get props => [];
}

final class OptionsSelectionInitial extends OptionsSelectionState {}

final class OptionsSelectionLoadingState extends OptionsSelectionState {
  const OptionsSelectionLoadingState();

  @override
  List<Object> get props => [];
}

final class OptionsSelectionLoadedState extends OptionsSelectionState {
  final OptionsSelections optionsSelection;

  const OptionsSelectionLoadedState({
    required this.optionsSelection,
  });

  @override
  List<Object> get props => [optionsSelection];
}

final class OptionsSelectionErrorState extends OptionsSelectionState {
  final Failure failure;

  const OptionsSelectionErrorState({
    required this.failure,
  });

  @override
  List<Object> get props => [failure];
}
