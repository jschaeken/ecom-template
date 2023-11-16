import 'package:ecom_template/features/checkout/domain/entities/attribute.dart';
import 'package:ecom_template/features/checkout/domain/entities/product_variant_checkout.dart';
import 'package:ecom_template/features/order/domain/entities/discount_allocations.dart';
import 'package:equatable/equatable.dart';

class ShopLineItem extends Equatable {
  final String title;
  final int quantity;
  final List<ShopDiscountAllocations> discountAllocations;
  final List<ShopAttribute> customAttributes;
  final String? variantId;
  final String? id;
  final ShopProductVariantCheckout? variant;

  const ShopLineItem({
    required this.title,
    required this.quantity,
    required this.discountAllocations,
    required this.customAttributes,
    this.variantId,
    this.id,
    this.variant,
  });

  @override
  List<Object?> get props => [
        title,
        quantity,
        discountAllocations,
        customAttributes,
        variantId,
        id,
        variant,
      ];
}
