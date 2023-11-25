import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/favorites/domain/entities/favorite.dart';
import 'package:ecom_template/features/favorites/domain/usecases/add_favorite.dart';
import 'package:ecom_template/features/favorites/domain/usecases/get_favorite_by_id.dart';
import 'package:ecom_template/features/favorites/domain/usecases/get_favorites.dart';
import 'package:ecom_template/features/favorites/domain/usecases/remove_favorite.dart';
import 'package:ecom_template/features/favorites/domain/usecases/shared.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:ecom_template/features/shop/domain/usecases/get_concrete_product_by_id.dart';
import 'package:equatable/equatable.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final AddFavorite addFavoriteUseCase;
  final RemoveFavorite removeFavoriteUseCase;
  final GetFavoriteById getFavoriteUseCase;
  final GetFavorites getFavoritesUseCase;
  final GetProductById getProductById;

  FavoritesBloc({
    required this.addFavoriteUseCase,
    required this.removeFavoriteUseCase,
    required this.getFavoritesUseCase,
    required this.getProductById,
    required this.getFavoriteUseCase,
  }) : super(FavoritesInitial()) {
    on<FavoritesEvent>((event, emit) async {
      switch (event.runtimeType) {
        case ToggleFavoriteEvent:
          event as ToggleFavoriteEvent;
          final id = event.productId;
          final result = await getFavoriteUseCase(
            Params(id: id),
          );
          await result.fold(
            (failure) async {},
            (favorite) async {
              log('Favorite: $favorite');
              if (favorite == null) {
                final result = await addFavoriteUseCase(
                  FavoriteParams(favorite: Favorite(parentProdId: id)),
                );
                await result.fold((failure) async {
                  emit(FavoritesError(message: failure.toString()));
                }, (success) async {
                  _getUpdatedFavoriteProductsLists(emit);
                });
              } else {
                final result = await removeFavoriteUseCase(
                  FavoriteParams(favorite: favorite),
                );
                await result.fold((failure) async {
                  emit(FavoritesError(message: failure.toString()));
                }, (success) async {
                  _getUpdatedFavoriteProductsLists(emit);
                });
              }
            },
          );
          break;
        case GetFavoritesEvent:
          final result = await _getUpdatedFavoriteProductsLists(emit);
          emit(FavoritesLoaded(favorites: result));
          break;
      }
    });
  }

  Future<Favorites> _getUpdatedFavoriteProductsLists(
      Emitter<FavoritesState> emit) async {
    final favorites = await getFavoritesUseCase(NoParams());
    return await favorites.fold((failure) async {
      return const Favorites();
    }, (favorites) async {
      return Favorites(
        favorites: favorites,
      );
    });
  }
}
