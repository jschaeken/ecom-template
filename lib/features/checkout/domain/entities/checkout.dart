import 'package:ecom_template/features/checkout/domain/entities/applied_gift_cards.dart';
import 'package:ecom_template/features/checkout/domain/entities/available_shipping_rates.dart';
import 'package:ecom_template/features/checkout/domain/entities/line_item.dart';
import 'package:ecom_template/features/checkout/domain/entities/shipping_address.dart';
import 'package:ecom_template/features/checkout/domain/entities/shipping_rate.dart';
import 'package:ecom_template/features/order/domain/entities/order.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:equatable/equatable.dart';

/// Copy of the [Checkout] model from the shopify_flutter package
class ShopCheckout extends Equatable {
  final String id;
  final bool ready;
  final ShopAvailableShippingRates? availableShippingRates;
  final String createdAt;
  final String currencyCode;
  final Price totalTax;
  final Price totalPrice;
  final bool taxesIncluded;
  final bool taxExempt;
  final Price subtotalPrice;
  final bool requiresShipping;
  final List<ShopAppliedGiftCards> appliedGiftCards;
  final List<ShopLineItem> lineItems;
  final ShopOrder? order;
  final String? orderStatusUrl;
  final String? shopifyPaymentsAccountId;
  final ShopShippingAddress? shippingAddress;
  final List<ShopShippingRate>? shippingLine;
  final String? email;
  final String? completedAt;
  final String? note;
  final String? webUrl;
  final String? updatedAt;

  const ShopCheckout({
    required this.id,
    required this.ready,
    required this.availableShippingRates,
    required this.createdAt,
    required this.currencyCode,
    required this.totalTax,
    required this.totalPrice,
    required this.taxesIncluded,
    required this.taxExempt,
    required this.subtotalPrice,
    required this.requiresShipping,
    required this.lineItems,
    this.appliedGiftCards = const [],
    this.order,
    this.orderStatusUrl,
    this.shopifyPaymentsAccountId,
    this.shippingAddress,
    this.shippingLine,
    this.email,
    this.completedAt,
    this.note,
    this.webUrl,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        ready,
        availableShippingRates,
        createdAt,
        currencyCode,
        totalTax,
        totalPrice,
        taxesIncluded,
        taxExempt,
        subtotalPrice,
        requiresShipping,
        appliedGiftCards,
        lineItems,
        order,
        orderStatusUrl,
        shopifyPaymentsAccountId,
        shippingAddress,
        shippingLine,
        email,
        completedAt,
        note,
        webUrl,
        updatedAt,
      ];
}
