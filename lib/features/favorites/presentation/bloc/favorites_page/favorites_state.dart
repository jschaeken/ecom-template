part of 'favorites_bloc.dart';

sealed class FavoritesState extends Equatable {
  final List<ShopProduct> favorites;

  const FavoritesState({this.favorites = const []});

  @override
  List<Object> get props => [];
}

final class FavoritesInitial extends FavoritesState {}

final class FavoritesLoading extends FavoritesState {}

final class FavoritesLoaded extends FavoritesState {
  @override
  final List<ShopProduct> favorites;

  const FavoritesLoaded({required this.favorites});

  @override
  List<Object> get props => [favorites];
}

final class FavoritesAddedLoaded extends FavoritesState {
  @override
  final List<ShopProduct> favorites;

  const FavoritesAddedLoaded({required this.favorites});

  @override
  List<Object> get props => [favorites];
}

final class FavoritesRemovedLoaded extends FavoritesState {
  @override
  final List<ShopProduct> favorites;

  const FavoritesRemovedLoaded({required this.favorites});

  @override
  List<Object> get props => [favorites];
}

final class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError({required this.message});

  @override
  List<Object> get props => [message];
}

final class FavoritesEmpty extends FavoritesState {
  @override
  final List<ShopProduct> favorites;

  const FavoritesEmpty({required this.favorites});

  @override
  List<Object> get props => [];
}
