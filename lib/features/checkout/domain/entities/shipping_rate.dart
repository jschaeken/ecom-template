import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:equatable/equatable.dart';
import 'package:shopify_flutter/models/src/checkout/shipping_rates/shipping_rates.dart';

class ShopShippingRate extends Equatable {
  final String handle;
  final String title;
  final Price price;

  const ShopShippingRate({
    required this.handle,
    required this.title,
    required this.price,
  });

  @override
  List<Object?> get props => [handle, title, price];

  static ShopShippingRate fromShippingRate(ShippingRates shippingRate) {
    return ShopShippingRate(
      handle: shippingRate.handle,
      title: shippingRate.title,
      price: Price.fromPriceV2(shippingRate.priceV2),
    );
  }
}
