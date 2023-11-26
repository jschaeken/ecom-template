part of 'favorites_bloc.dart';

sealed class FavoritesState extends Equatable {
  final List<Favorite> favorites;

  const FavoritesState({this.favorites = const <Favorite>[]});

  @override
  List<Object> get props => [favorites];
}

final class FavoritesInitial extends FavoritesState {}

final class FavoritesLoading extends FavoritesState {}

final class FavoritesLoaded extends FavoritesState {
  @override
  final List<Favorite> favorites;

  const FavoritesLoaded({required this.favorites});

  @override
  List<Object> get props => [favorites];
}

final class FavoritesAddedLoaded extends FavoritesState {
  @override
  final List<Favorite> favorites;

  const FavoritesAddedLoaded({required this.favorites});

  @override
  List<Object> get props => [favorites];
}

final class FavoritesRemovedLoaded extends FavoritesState {
  const FavoritesRemovedLoaded({required super.favorites});

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
  const FavoritesEmpty() : super(favorites: const []);

  @override
  List<Object> get props => [favorites];
}
