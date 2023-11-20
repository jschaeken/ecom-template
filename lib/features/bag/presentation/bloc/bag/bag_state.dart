part of 'bag_bloc.dart';

sealed class BagState extends Equatable {
  final List<BagItem> bagItems;
  final BagTotals bagTotals;
  const BagState(
      {this.bagItems = const [], this.bagTotals = const BagTotals()});

  @override
  List<Object> get props => [];
}

final class BagInitial extends BagState {}

final class BagLoadingState extends BagState {}

final class BagLoadedState extends BagState {
  @override
  final List<BagItem> bagItems;
  @override
  final BagTotals bagTotals;

  const BagLoadedState({required this.bagItems, required this.bagTotals});

  @override
  List<Object> get props => [bagItems, bagTotals];
}

final class BagLoadedAddedState extends BagState {
  @override
  final List<BagItem> bagItems;
  @override
  final BagTotals bagTotals;

  const BagLoadedAddedState({required this.bagItems, required this.bagTotals});

  @override
  List<Object> get props => [bagItems, bagTotals];
}

final class BagLoadedRemovedState extends BagState {
  @override
  final List<BagItem> bagItems;
  @override
  final BagTotals bagTotals;

  const BagLoadedRemovedState(
      {required this.bagItems, required this.bagTotals});

  @override
  List<Object> get props => [bagItems];
}

final class BagErrorState extends BagState {
  final Failure failure;

  const BagErrorState({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class BagEmptyState extends BagState {}
