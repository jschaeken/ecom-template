import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/checkout/domain/entities/checkout.dart';
import 'package:ecom_template/features/checkout/domain/entities/line_item.dart';
import 'package:ecom_template/features/checkout/domain/entities/shipping_address.dart';
import 'package:ecom_template/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:equatable/equatable.dart';

class CreateCheckout extends UseCase<ShopCheckout, ShopCheckoutParams> {
  final CheckoutRepository repository;

  CreateCheckout({required this.repository});

  @override
  Future<Either<Failure, ShopCheckout>> call(ShopCheckoutParams params) async {
    final response = await repository.createCheckout(
      lineItems: params.lineItems,
      shippingAddress: params.shippingAddress,
      email: params.email,
    );
    return response;
  }
}

class ShopCheckoutParams extends Equatable {
  final List<ShopLineItem>? lineItems;
  final ShopShippingAddress? shippingAddress;
  final String? email;

  const ShopCheckoutParams({this.lineItems, this.shippingAddress, this.email});

  @override
  List<Object?> get props => [lineItems, shippingAddress, email];
}
