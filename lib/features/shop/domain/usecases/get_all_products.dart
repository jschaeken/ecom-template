import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:ecom_template/features/shop/domain/repositories/product_repository.dart';

class GetAllProducts implements UseCase<List<ShopProduct>, NoParams> {
  final ProductRepository repository;

  GetAllProducts({required this.repository});

  @override
  Future<Either<Failure, List<ShopProduct>>> call(NoParams params) async {
    return await repository.getFullProducts();
  }
}
