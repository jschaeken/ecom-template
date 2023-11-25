import 'package:ecom_template/features/checkout/domain/entities/applied_gift_cards.dart';
import 'package:ecom_template/features/checkout/domain/entities/available_shipping_rates.dart';
import 'package:ecom_template/features/checkout/domain/entities/checkout.dart';
import 'package:ecom_template/features/checkout/domain/entities/checkout_user_error.dart';
import 'package:ecom_template/features/checkout/domain/entities/line_item.dart';
import 'package:ecom_template/features/checkout/domain/entities/shipping_address.dart';
import 'package:ecom_template/features/checkout/domain/entities/shipping_rate.dart';
import 'package:ecom_template/features/order/domain/entities/order.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:shopify_flutter/models/models.dart';
import 'package:shopify_flutter/models/src/order/discount_allocations/discount_allocations.dart';

class ShopCheckoutModel extends ShopCheckout {
  const ShopCheckoutModel({
    required super.id,
    required super.ready,
    required super.availableShippingRates,
    required super.createdAt,
    required super.currencyCode,
    required super.totalTax,
    required super.totalPrice,
    required super.taxesIncluded,
    required super.taxExempt,
    required super.subtotalPrice,
    required super.requiresShipping,
    required super.lineItems,
    super.appliedGiftCards,
    super.order,
    super.orderStatusUrl,
    super.shopifyPaymentsAccountId,
    super.shippingAddress,
    super.shippingLine,
    super.email,
    super.completedAt,
    super.note,
    super.webUrl,
    super.updatedAt,
    super.totalDiscountApplied,
    super.discountCodesApplied,
    super.userErrors,
  });

  //copyWith method
  ShopCheckoutModel copyWith({
    String? id,
    bool? ready,
    ShopAvailableShippingRates? availableShippingRates,
    String? createdAt,
    String? currencyCode,
    Price? totalTax,
    Price? totalPrice,
    bool? taxesIncluded,
    bool? taxExempt,
    Price? subtotalPrice,
    bool? requiresShipping,
    List<ShopAppliedGiftCards>? appliedGiftCards,
    List<ShopLineItem>? lineItems,
    ShopOrder? order,
    String? orderStatusUrl,
    String? shopifyPaymentsAccountId,
    ShopShippingAddress? shippingAddress,
    List<ShopShippingRate>? shippingLine,
    String? email,
    String? completedAt,
    String? note,
    String? webUrl,
    String? updatedAt,
    Price? totalDiscountApplied,
    List<String>? discountCodesApplied,
    List<CheckoutUserError>? userErrors,
  }) {
    return ShopCheckoutModel(
      id: id ?? this.id,
      ready: ready ?? this.ready,
      availableShippingRates:
          availableShippingRates ?? this.availableShippingRates,
      createdAt: createdAt ?? this.createdAt,
      currencyCode: currencyCode ?? this.currencyCode,
      totalTax: totalTax ?? this.totalTax,
      totalPrice: totalPrice ?? this.totalPrice,
      taxesIncluded: taxesIncluded ?? this.taxesIncluded,
      taxExempt: taxExempt ?? this.taxExempt,
      subtotalPrice: subtotalPrice ?? this.subtotalPrice,
      requiresShipping: requiresShipping ?? this.requiresShipping,
      appliedGiftCards: appliedGiftCards ?? this.appliedGiftCards,
      lineItems: lineItems ?? this.lineItems,
      order: order ?? this.order,
      orderStatusUrl: orderStatusUrl ?? this.orderStatusUrl,
      shopifyPaymentsAccountId:
          shopifyPaymentsAccountId ?? this.shopifyPaymentsAccountId,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      shippingLine: shippingLine ?? this.shippingLine,
      email: email ?? this.email,
      completedAt: completedAt ?? this.completedAt,
      note: note ?? this.note,
      webUrl: webUrl ?? this.webUrl,
      updatedAt: updatedAt ?? this.updatedAt,
      totalDiscountApplied: totalDiscountApplied ?? this.totalDiscountApplied,
      discountCodesApplied: discountCodesApplied ?? this.discountCodesApplied,
      userErrors: userErrors ?? this.userErrors,
    );
  }

  static ShopCheckoutModel fromShopifyCheckout(Checkout checkout) {
    return ShopCheckoutModel(
      id: checkout.id,
      ready: checkout.ready,
      availableShippingRates: checkout.availableShippingRates != null
          ? ShopAvailableShippingRates.fromAvailableShippingRates(
              checkout.availableShippingRates!)
          : null,
      createdAt: checkout.createdAt,
      currencyCode: checkout.currencyCode,
      totalTax: Price.fromPriceV2(checkout.totalTaxV2),
      totalPrice: Price.fromPriceV2(checkout.totalPriceV2),
      taxesIncluded: checkout.taxesIncluded,
      taxExempt: checkout.taxExempt,
      subtotalPrice: Price.fromPriceV2(checkout.subtotalPriceV2),
      requiresShipping: checkout.requiresShipping,
      lineItems: checkout.lineItems
          .map((lineItem) => ShopLineItem.fromLineItem(lineItem))
          .toList(),
      appliedGiftCards: checkout.appliedGiftCards
          .map((appliedGiftCard) =>
              ShopAppliedGiftCards.fromAppliedGiftCards(appliedGiftCard))
          .toList(),
      order:
          checkout.order != null ? ShopOrder.fromOrder(checkout.order!) : null,
      orderStatusUrl: checkout.orderStatusUrl,
      shopifyPaymentsAccountId: checkout.shopifyPaymentsAccountId,
      shippingAddress: checkout.shippingAddress != null
          ? ShopShippingAddress.fromMailingAddress(checkout.shippingAddress!)
          : null,
      shippingLine: checkout.shippingLine != null
          ? [ShopShippingRate.fromShippingRate(checkout.shippingLine!)]
          : null,
      email: checkout.email,
      completedAt: checkout.completedAt,
      note: checkout.note,
      webUrl: checkout.webUrl,
      updatedAt: checkout.updatedAt,
      totalDiscountApplied: Price(
        amount: _calculateTotalDiscountAmount(checkout.lineItems),
        currencyCode: checkout.currencyCode,
      ),
    );
  }
}

double _calculateTotalDiscountAmount(List<LineItem> lineItems) {
  double totalDiscount = 0;
  for (LineItem lineItem in lineItems) {
    for (DiscountAllocations discount in lineItem.discountAllocations) {
      totalDiscount += discount.allocatedAmount?.amount ?? 0;
    }
  }
  return totalDiscount;
}
