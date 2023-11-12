import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:ecom_template/features/favorites/domain/usecases/shared.dart';

class AddFavorite extends UseCase<void, FavoriteParams> {
  AddFavorite({required this.repository});

  final FavoritesRepository repository;

  @override
  Future<Either<Failure, void>> call(FavoriteParams params) async {
    return await repository.addFavorite(params.favorite);
  }
}
