import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/favorites/domain/entities/favorite.dart';
import 'package:ecom_template/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:ecom_template/features/favorites/domain/usecases/shared.dart';

class GetFavoriteById extends UseCase<void, Params> {
  final FavoritesRepository repository;

  GetFavoriteById({required this.repository});

  @override
  Future<Either<Failure, Favorite?>> call(Params params) async {
    return await repository.getFavoriteById(params.id);
  }
}
