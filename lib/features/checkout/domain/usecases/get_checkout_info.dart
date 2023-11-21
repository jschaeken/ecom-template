import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/checkout/domain/entities/checkout.dart';
import 'package:ecom_template/features/checkout/domain/repositories/checkout_repository.dart';

class GetCheckoutInfo extends UseCase<ShopCheckout, Params> {
  final CheckoutRepository repository;

  GetCheckoutInfo({required this.repository});

  @override
  Future<Either<Failure, ShopCheckout>> call(Params params) async {
    return await repository.getCheckoutById(checkoutId: params.id);
  }
}
