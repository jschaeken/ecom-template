part of 'favorites_bloc.dart';

sealed class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class AddFavoriteEvent extends FavoritesEvent {
  final Favorite favorite;

  const AddFavoriteEvent({required this.favorite});

  @override
  List<Object> get props => [favorite];
}

class RemoveFavoriteEvent extends FavoritesEvent {
  final Favorite favorite;

  const RemoveFavoriteEvent({required this.favorite});

  @override
  List<Object> get props => [favorite];
}

class GetFavoritesEvent extends FavoritesEvent {}
