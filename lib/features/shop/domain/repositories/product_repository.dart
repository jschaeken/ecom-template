import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ShopProduct>>> getFullProducts();
  Future<Either<Failure, ShopProduct>> getProductById(String id);
  Future<Either<Failure, List<ShopProduct>>> getReviewsForProductid(String id);
}
