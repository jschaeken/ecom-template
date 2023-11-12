part of 'bag_bloc.dart';

sealed class BagState extends Equatable {
  final List<BagItem> bagItems;
  const BagState({this.bagItems = const []});

  @override
  List<Object> get props => [];
}

final class BagInitial extends BagState {}

final class BagLoadingState extends BagState {}

final class BagLoadedState extends BagState {
  @override
  final List<BagItem> bagItems;

  const BagLoadedState({required this.bagItems});

  @override
  List<Object> get props => [bagItems];
}

final class BagLoadedAddedState extends BagState {
  @override
  final List<BagItem> bagItems;

  const BagLoadedAddedState({required this.bagItems});

  @override
  List<Object> get props => [bagItems];
}

final class BagLoadedRemovedState extends BagState {
  @override
  final List<BagItem> bagItems;

  const BagLoadedRemovedState({required this.bagItems});

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
