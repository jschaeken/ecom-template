import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/features/customer/domain/entities/shopify_user.dart';

abstract class CustomerAuthRepository {
  Future<Either<Failure, ShopShopifyUser>> signInWithEmailAndPassword(
      {required String email, required String password});
}
