import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/customer/domain/entities/shopify_user.dart';
import 'package:ecom_template/features/customer/domain/repositories/customer_auth_repository.dart';

class GetAuthState extends UseCase<ShopShopifyUser?, NoParams> {
  final CustomerAuthRepository repository;

  GetAuthState({required this.repository});

  @override
  Future<Either<Failure, ShopShopifyUser?>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}
