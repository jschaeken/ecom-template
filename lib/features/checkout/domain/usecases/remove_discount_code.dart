import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/checkout/domain/entities/checkout.dart';
import 'package:ecom_template/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:ecom_template/features/checkout/domain/usecases/add_discount_code.dart';

class RemoveDiscountCode
    extends UseCase<ShopCheckout, ShopCheckoutActionParams> {
  final CheckoutRepository repository;

  RemoveDiscountCode({required this.repository});

  @override
  Future<Either<Failure, WriteSuccess>> call(
      ShopCheckoutActionParams params) async {
    return await repository.removeDiscountCode(
      checkoutId: params.checkoutId,
      discountCode: params.option ?? '',
    );
  }
}
