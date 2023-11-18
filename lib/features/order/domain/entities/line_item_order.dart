import 'package:ecom_template/features/checkout/domain/entities/product_variant_checkout.dart';
import 'package:ecom_template/features/order/domain/entities/discount_allocations.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:equatable/equatable.dart';
import 'package:shopify_flutter/models/src/order/line_item_order/line_item_order.dart';

class ShopLineItemOrder extends Equatable {
  final int currentQuantity;
  final Price discountedTotalPrice;
  final Price originalTotalPrice;
  final int quantity;
  final String title;
  final List<ShopDiscountAllocations> discountAllocations;
  final ShopProductVariantCheckout? variant;

  const ShopLineItemOrder({
    required this.currentQuantity,
    required this.discountedTotalPrice,
    required this.originalTotalPrice,
    required this.quantity,
    required this.title,
    required this.discountAllocations,
    required this.variant,
  });

  @override
  List<Object?> get props => [
        currentQuantity,
        discountedTotalPrice,
        originalTotalPrice,
        quantity,
        title,
        discountAllocations,
        variant,
      ];

  static ShopLineItemOrder fromLineItemOrder(LineItemOrder lineItemOrder) {
    return ShopLineItemOrder(
      currentQuantity: lineItemOrder.currentQuantity,
      discountedTotalPrice:
          Price.fromPriceV2(lineItemOrder.discountedTotalPrice),
      originalTotalPrice: Price.fromPriceV2(lineItemOrder.originalTotalPrice),
      quantity: lineItemOrder.quantity,
      title: lineItemOrder.title,
      discountAllocations: lineItemOrder.discountAllocations
          .map((discountAllocations) =>
              ShopDiscountAllocations.fromDiscountAllocation(
                  discountAllocations))
          .toList() as List<ShopDiscountAllocations>,
      variant: lineItemOrder.variant != null
          ? ShopProductVariantCheckout.fromProductVariantCheckout(
              lineItemOrder.variant!)
          : null,
    );
  }
}
