import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:ecom_template/features/shop/domain/repositories/product_repository.dart';

class GetProductById implements UseCase<Type, Params> {
  final ProductRepository repository;

  GetProductById({required this.repository});

  @override
  Future<Either<Failure, ShopProduct>> call(Params params) {
    return repository.getProductById(params.id);
  }
}
