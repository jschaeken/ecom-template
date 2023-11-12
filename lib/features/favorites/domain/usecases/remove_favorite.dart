import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:ecom_template/features/favorites/domain/usecases/shared.dart';

class RemoveFavorite extends UseCase<void, FavoriteParams> {
  final FavoritesRepository repository;

  RemoveFavorite({required this.repository});

  @override
  Future<Either<Failure, WriteSuccess>> call(FavoriteParams params) async {
    return await repository.removeFavorite(params.favorite);
  }
}
