import 'package:ecom_template/features/checkout/domain/entities/applied_gift_cards.dart';
import 'package:ecom_template/features/checkout/domain/entities/available_shipping_rates.dart';
import 'package:ecom_template/features/checkout/domain/entities/checkout.dart';
import 'package:ecom_template/features/checkout/domain/entities/line_item.dart';
import 'package:ecom_template/features/checkout/domain/entities/shipping_address.dart';
import 'package:ecom_template/features/checkout/domain/entities/shipping_rate.dart';
import 'package:ecom_template/features/order/domain/entities/order.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:shopify_flutter/models/models.dart';
import 'package:shopify_flutter/models/src/checkout/checkout.dart';

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
  });

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
          .toList() as List<ShopLineItem>,
      appliedGiftCards: checkout.appliedGiftCards
          .map((appliedGiftCard) =>
              ShopAppliedGiftCards.fromAppliedGiftCards(appliedGiftCard))
          .toList() as List<ShopAppliedGiftCards>,
      order: ShopOrder.fromOrder(checkout.order),
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
    );
  }
}
