import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:ecom_template/features/shop/domain/repositories/product_repository.dart';

class GetProductsBySubstring extends UseCase<List<ShopProduct>, Params> {
  GetProductsBySubstring({required this.repository});

  final ProductRepository repository;

  @override
  Future<Either<Failure, List<ShopProduct>>> call(Params params) async {
    return await repository.getProductsBySubstring(params.id);
  }
}
