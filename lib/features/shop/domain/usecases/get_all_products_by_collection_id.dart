import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:ecom_template/features/shop/domain/repositories/product_repository.dart';

class GetAllProductsByCollectionId extends UseCase<List<ShopProduct>, Params> {
  ProductRepository repository;

  GetAllProductsByCollectionId({required this.repository});

  @override
  Future<Either<Failure, dynamic>> call(Params params) async {
    return await repository.getAllProductsByCollectionId(params.id);
  }
}
