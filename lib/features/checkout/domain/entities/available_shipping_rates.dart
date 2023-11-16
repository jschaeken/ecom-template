import 'package:ecom_template/features/checkout/domain/entities/shipping_rate.dart';
import 'package:equatable/equatable.dart';

class ShopAvailableShippingRates extends Equatable {
  final List<ShopShippingRate>? shippingRates;

  const ShopAvailableShippingRates({required this.shippingRates});

  @override
  List<Object?> get props => [shippingRates];
}
