import 'package:ecom_template/features/checkout/domain/entities/shipping_rate.dart';
import 'package:equatable/equatable.dart';
import 'package:shopify_flutter/models/src/checkout/available_shipping_rates/available_shipping_rates.dart';

class ShopAvailableShippingRates extends Equatable {
  final bool ready;
  final List<ShopShippingRate>? shippingRates;

  const ShopAvailableShippingRates(
      {required this.ready, required this.shippingRates});

  @override
  List<Object?> get props => [ready, shippingRates];

  static ShopAvailableShippingRates fromAvailableShippingRates(
      AvailableShippingRates availableShippingRates) {
    return ShopAvailableShippingRates(
      ready: availableShippingRates.ready,
      shippingRates: availableShippingRates.shippingRates != null
          ? availableShippingRates.shippingRates!
              .map((shippingRate) =>
                  ShopShippingRate.fromShippingRate(shippingRate))
              .toList()
          : null,
    );
  }
}
