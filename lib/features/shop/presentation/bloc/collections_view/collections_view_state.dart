part of 'collections_view_bloc.dart';

sealed class CollectionsViewState extends Equatable {
  const CollectionsViewState();

  @override
  List<Object> get props => [];
}

final class CollectionsViewInitial extends CollectionsViewState {}

final class CollectionsViewLoading extends CollectionsViewState {}

final class CollectionsViewLoaded extends CollectionsViewState {
  final List<ShopCollection> collections;

  const CollectionsViewLoaded({required this.collections});

  @override
  List<Object> get props => [collections];
}

final class CollectionsViewError extends CollectionsViewState {
  final String message;
  final Failure failure;

  const CollectionsViewError({required this.message, required this.failure});

  @override
  List<Object> get props => [message];
}

final class CollectionsViewEmpty extends CollectionsViewState {}
