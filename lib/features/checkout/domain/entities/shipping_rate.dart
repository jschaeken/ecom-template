import 'package:equatable/equatable.dart';

class ShopShippingRate extends Equatable {
  final ShopShippingRate shippingRate;

  const ShopShippingRate({
    required this.shippingRate,
  });

  @override
  List<Object?> get props => [shippingRate];
}
