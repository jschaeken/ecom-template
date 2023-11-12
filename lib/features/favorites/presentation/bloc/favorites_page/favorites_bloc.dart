import 'package:bloc/bloc.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/favorites/domain/entities/favorite.dart';
import 'package:ecom_template/features/favorites/domain/usecases/add_favorite.dart';
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
  final GetFavorites getFavoritesUseCase;
  final GetProductById getProductById;

  FavoritesBloc({
    required this.addFavoriteUseCase,
    required this.removeFavoriteUseCase,
    required this.getFavoritesUseCase,
    required this.getProductById,
  }) : super(FavoritesInitial()) {
    on<FavoritesEvent>((event, emit) async {
      switch (event.runtimeType) {
        case AddFavoriteEvent:
          event as AddFavoriteEvent;
          // emit(FavoritesLoading());
          final result = await addFavoriteUseCase(
              FavoriteParams(favorite: event.favorite));
          await result.fold(
              (failure) async =>
                  emit(FavoritesError(message: failure.toString())),
              (success) async {
            final favorites = await _getUpdatedFavoriteProductsLists(emit);
            if (favorites != null && favorites.isNotEmpty) {
              emit(FavoritesLoaded(favorites: favorites));
            } else {
              emit(const FavoritesEmpty(favorites: []));
            }
          });
          break;
        case RemoveFavoriteEvent:
          // emit(FavoritesLoading());
          event as RemoveFavoriteEvent;
          final result = await removeFavoriteUseCase(
              FavoriteParams(favorite: event.favorite));
          await result.fold(
              (failure) async =>
                  emit(FavoritesError(message: failure.toString())),
              (success) async {
            final favorites = await _getUpdatedFavoriteProductsLists(emit);
            if (favorites != null && favorites.isNotEmpty) {
              emit(FavoritesLoaded(favorites: favorites));
            } else {
              emit(const FavoritesEmpty(favorites: []));
            }
          });
          break;
        case GetFavoritesEvent:
          // emit(FavoritesLoading());
          final favorites = await _getUpdatedFavoriteProductsLists(emit);
          if (favorites != null && favorites.isNotEmpty) {
            emit(FavoritesLoaded(favorites: favorites));
          } else {
            emit(const FavoritesEmpty(favorites: []));
          }
          break;
      }
    });
  }

  Future<List<ShopProduct>?> _getUpdatedFavoriteProductsLists(
      Emitter<FavoritesState> emit) async {
    final favorites = await getFavoritesUseCase(NoParams());
    return await favorites.fold((failure) async {
      return null;
    }, (favorites) async {
      List<ShopProduct> favoritesList = [];
      for (var favorite in favorites) {
        final product = await getProductById(Params(id: favorite.parentProdId));
        await product.fold(
            (failure) async =>
                emit(FavoritesError(message: failure.toString())),
            (product) async {
          favoritesList.add(product);
        });
      }
      return favoritesList;
    });
  }
}
