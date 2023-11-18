import 'package:ecom_template/features/checkout/domain/entities/shipping_address.dart';
import 'package:ecom_template/features/order/domain/entities/line_items_order.dart';
import 'package:ecom_template/features/order/domain/entities/successful_fulfilment.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:equatable/equatable.dart';
import 'package:shopify_flutter/models/src/order/order.dart';

class ShopOrder extends Equatable {
  final String id;
  final String email;
  final String currencyCode;
  final String customerUrl;
  final ShopLineItemsOrder lineItems;
  final String name;
  final int orderNumber;
  final String processedAt;
  final ShopShippingAddress shippingAddress;
  final ShopShippingAddress? billingAddress;
  final String statusUrl;
  final Price subtotalPrice;
  final Price totalPrice;
  final Price totalShippingPrice;
  final Price totalTax;
  final String financialStatus;
  final String fulfillmentStatus;
  final Price? totalRefunded;
  final String? phone;
  final String? cursor;
  final List<ShopSuccessfulFulfilment>? successfulFulfillments;

  const ShopOrder({
    required this.id,
    required this.email,
    required this.currencyCode,
    required this.customerUrl,
    required this.lineItems,
    required this.name,
    required this.orderNumber,
    required this.processedAt,
    required this.shippingAddress,
    required this.billingAddress,
    required this.statusUrl,
    required this.subtotalPrice,
    required this.totalPrice,
    required this.totalShippingPrice,
    required this.totalTax,
    required this.financialStatus,
    required this.fulfillmentStatus,
    this.totalRefunded,
    this.phone,
    this.cursor,
    this.successfulFulfillments,
  });
  @override
  List<Object?> get props => [
        id,
        email,
        currencyCode,
        customerUrl,
        lineItems,
        name,
        orderNumber,
        processedAt,
        shippingAddress,
        billingAddress,
        statusUrl,
        subtotalPrice,
        totalPrice,
        totalShippingPrice,
        totalTax,
        financialStatus,
        fulfillmentStatus,
        totalRefunded,
        phone,
        cursor,
        successfulFulfillments,
      ];

  static fromOrder(Order? order) {
    return ShopOrder(
      id: order!.id,
      email: order.email,
      currencyCode: order.currencyCode,
      customerUrl: order.customerUrl,
      lineItems: ShopLineItemsOrder.fromLineItems(order.lineItems),
      name: order.name,
      orderNumber: order.orderNumber,
      processedAt: order.processedAt,
      shippingAddress:
          ShopShippingAddress.fromShippingAddress(order.shippingAddress),
      billingAddress: order.billingAddress != null
          ? ShopShippingAddress.fromShippingAddress(order.billingAddress!)
          : null,
      statusUrl: order.statusUrl,
      subtotalPrice: Price.fromPriceV2(order.subtotalPriceV2),
      totalPrice: Price.fromPriceV2(order.totalPriceV2),
      totalShippingPrice: Price.fromPriceV2(order.totalShippingPriceV2),
      totalTax: Price.fromPriceV2(order.totalTaxV2),
      financialStatus: order.financialStatus,
      fulfillmentStatus: order.fulfillmentStatus,
      totalRefunded: order.totalRefundedV2 != null
          ? Price.fromPriceV2(order.totalRefundedV2!)
          : null,
      phone: order.phone,
      cursor: order.cursor,
      successfulFulfillments: order.successfulFulfillments != null
          ? order.successfulFulfillments!
              .map((fulfilment) =>
                  ShopSuccessfulFulfilment.fromFulfilment(fulfilment))
              .toList() as List<ShopSuccessfulFulfilment>
          : null,
    );
  }
}
