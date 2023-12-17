import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/features/favorites/domain/entities/favorite.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<Favorite>>> getFavorites();

  Future<Either<Failure, WriteSuccess>> addFavorite(Favorite favorite);

  Future<Either<Failure, WriteSuccess>> removeFavorite(Favorite favorite);

  Future<Either<Failure, Favorite?>> getFavoriteById(String id);

  Future<Either<Failure, WriteSuccess>> removeAllFavorites();
}
