import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/features/customer/domain/entities/shopify_user.dart';

abstract class CustomerAuthRepository {
  Future<Either<Failure, ShopShopifyUser>> signInWithEmailAndPassword(
      {required String email, required String password});

  Future<Either<Failure, ShopShopifyUser?>> getCurrentUser();

  Future<Either<Failure, WriteSuccess>> signOut();

  Future<Either<Failure, ShopShopifyUser>> createAccount({
    required String email,
    required String password,
    required String confirmPassword,
    String? firstName,
    String? lastName,
    String? phone,
    bool? acceptsMarketing,
  });
}
