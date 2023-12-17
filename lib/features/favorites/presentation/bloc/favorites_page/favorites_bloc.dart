import 'package:bloc/bloc.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/favorites/domain/entities/favorite.dart';
import 'package:ecom_template/features/favorites/domain/usecases/add_favorite.dart';
import 'package:ecom_template/features/favorites/domain/usecases/get_favorite_by_id.dart';
import 'package:ecom_template/features/favorites/domain/usecases/get_favorites.dart';
import 'package:ecom_template/features/favorites/domain/usecases/remove_all_favorites.dart';
import 'package:ecom_template/features/favorites/domain/usecases/remove_favorite.dart';
import 'package:ecom_template/features/favorites/domain/usecases/shared.dart';
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
  final RemoveAllFavorites removeAllFavorites;

  FavoritesBloc({
    required this.addFavoriteUseCase,
    required this.removeFavoriteUseCase,
    required this.getFavoritesUseCase,
    required this.getProductById,
    required this.getFavoriteUseCase,
    required this.removeAllFavorites,
  }) : super(FavoritesInitial()) {
    on<FavoritesEvent>((event, emit) async {
      switch (event.runtimeType) {
        case AddFavoriteEvent:
          event as AddFavoriteEvent;
          final result = await addFavoriteUseCase(
              FavoriteParams(favorite: event.favorite));
          await result.fold(
            (failure) async {
              emit(FavoritesError(message: failure.toString()));
            },
            (success) async {
              final favorites = await _getUpdatedFavoriteProductsLists(emit);
              if (favorites.isNotEmpty) {
                emit(FavoritesLoaded(favorites: favorites));
              } else {
                emit(const FavoritesEmpty());
              }
            },
          );
          break;
        case RemoveFavoriteEvent:
          event as RemoveFavoriteEvent;
          final result = await removeFavoriteUseCase(
              FavoriteParams(favorite: event.favorite));
          await result.fold(
            (failure) async {
              emit(FavoritesError(message: failure.toString()));
            },
            (success) async {
              final favorites = await _getUpdatedFavoriteProductsLists(emit);
              if (favorites.isNotEmpty) {
                emit(FavoritesLoaded(favorites: favorites));
              } else {
                emit(const FavoritesEmpty());
              }
            },
          );
          break;
        case GetAllFavoritesEvent:
          final result = await _getUpdatedFavoriteProductsLists(emit);
          emit(FavoritesLoaded(favorites: result));
          break;
        case ClearFavoritesEvent:
          await removeAllFavorites(NoParams());
          emit(const FavoritesEmpty());
          break;
      }
    });
  }

  Future<List<Favorite>> _getUpdatedFavoriteProductsLists(
      Emitter<FavoritesState> emit) async {
    final favorites = await getFavoritesUseCase(NoParams());
    return await favorites.fold((failure) async {
      return const <Favorite>[];
    }, (favorites) async {
      return favorites;
    });
  }
}
