import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:ecom_template/features/favorites/domain/entities/favorite.dart';
import 'package:ecom_template/features/favorites/domain/repositories/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource localDataSource;

  FavoritesRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Favorite>>> getFavorites() async {
    try {
      List<Favorite> favorites = await localDataSource.getFavorites();
      return Right(favorites);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, WriteSuccess>> addFavorite(Favorite favorite) async {
    try {
      await localDataSource.addFavorite(favorite);
      return const Right(WriteSuccess());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, WriteSuccess>> removeFavorite(
      Favorite favorite) async {
    try {
      localDataSource.removeFavorite(favorite.parentProdId);
      return const Right(WriteSuccess());
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
