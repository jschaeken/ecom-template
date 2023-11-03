import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_collection.dart';
import 'package:ecom_template/features/shop/domain/repositories/product_repository.dart';

class GetAllCollections extends UseCase<ShopCollection, NoParams> {
  final ProductRepository repository;

  GetAllCollections(this.repository);

  @override
  Future<Either<Failure, dynamic>> call(NoParams params) async {
    return await repository.getAllCollections();
  }
}
