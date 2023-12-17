import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/favorites/domain/repositories/favorites_repository.dart';

class RemoveAllFavorites extends UseCase<void, NoParams> {
  final FavoritesRepository repository;

  RemoveAllFavorites({required this.repository});

  @override
  Future<Either<Failure, WriteSuccess>> call(NoParams params) async {
    return await repository.removeAllFavorites();
  }
}
