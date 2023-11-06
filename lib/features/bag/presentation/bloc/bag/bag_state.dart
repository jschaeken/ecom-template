part of 'bag_bloc.dart';

sealed class BagState extends Equatable {
  const BagState();

  @override
  List<Object> get props => [];
}

final class BagInitial extends BagState {}

final class BagLoadingState extends BagState {}

final class BagLoadedState extends BagState {
  final List<BagItem> bagItems;

  const BagLoadedState({required this.bagItems});

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
