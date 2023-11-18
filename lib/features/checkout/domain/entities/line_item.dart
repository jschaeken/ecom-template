import 'package:ecom_template/features/checkout/domain/entities/attribute.dart';
import 'package:ecom_template/features/checkout/domain/entities/product_variant_checkout.dart';
import 'package:ecom_template/features/order/domain/entities/discount_allocations.dart';
import 'package:equatable/equatable.dart';
import 'package:shopify_flutter/models/src/checkout/line_item/line_item.dart';

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

  static fromLineItem(LineItem lineItem) {
    return ShopLineItem(
      title: lineItem.title,
      quantity: lineItem.quantity,
      discountAllocations: lineItem.discountAllocations
          .map((discountAllocations) =>
              ShopDiscountAllocations.fromDiscountAllocation(
                  discountAllocations))
          .toList(),
      customAttributes: lineItem.customAttributes
          .map((attribute) => ShopAttribute.fromAttribute(attribute))
          .toList(),
      variantId: lineItem.variantId,
      id: lineItem.id,
      variant: lineItem.variant != null
          ? ShopProductVariantCheckout.fromProductVariantCheckout(
              lineItem.variant!)
          : null,
    );
  }

  LineItem toLineItem() {
    return LineItem(
      title: title,
      quantity: quantity,
      discountAllocations: discountAllocations
          .map((discountAllocations) =>
              discountAllocations.toDiscountAllocation())
          .toList(),
      variantId: variantId,
      id: id,
      variant: variant != null
          ? ShopProductVariantCheckout.toProductVariantCheckout(variant!)
          : null,
    );
  }
}
