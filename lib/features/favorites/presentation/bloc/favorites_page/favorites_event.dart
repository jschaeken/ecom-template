part of 'favorites_bloc.dart';

sealed class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class ToggleFavoriteEvent extends FavoritesEvent {
  final String productId;

  const ToggleFavoriteEvent({required this.productId});

  @override
  List<Object> get props => [productId];
}

class GetFavoritesEvent extends FavoritesEvent {}
