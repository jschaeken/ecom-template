import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/checkout/domain/entities/checkout.dart';
import 'package:ecom_template/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:equatable/equatable.dart';

class AddDiscountCode extends UseCase<ShopCheckout, ShopCheckoutActionParams> {
  final CheckoutRepository repository;

  AddDiscountCode({required this.repository});

  @override
  Future<Either<Failure, ShopCheckout>> call(
      ShopCheckoutActionParams params) async {
    return await repository.addDiscountCode(
      checkoutId: params.checkoutId,
      discountCode: params.option ?? '',
    );
  }
}

class ShopCheckoutActionParams extends Equatable {
  final String checkoutId;
  final String? option;

  const ShopCheckoutActionParams({
    required this.checkoutId,
    this.option,
  });

  @override
  List<Object?> get props => [checkoutId, option];
}
