import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/favorites/domain/entities/favorite.dart';
import 'package:ecom_template/features/favorites/domain/repositories/favorites_repository.dart';

class GetFavorites implements UseCase<List<Favorite>, NoParams> {
  final FavoritesRepository repository;

  GetFavorites({required this.repository});

  @override
  Future<Either<Failure, List<Favorite>>> call(NoParams params) async {
    return await repository.getFavorites();
  }
}
