import 'package:ecom_template/features/checkout/domain/entities/shipping_address.dart';
import 'package:ecom_template/features/order/domain/entities/line_items_order.dart';
import 'package:ecom_template/features/order/domain/entities/order.dart';
import 'package:ecom_template/features/order/domain/entities/successful_fulfilment.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:shopify_flutter/models/src/order/order.dart';
import 'package:shopify_flutter/models/src/order/successful_fulfillment/successful_fullfilment.dart';

class ShopOrderModel extends ShopOrder {
  const ShopOrderModel({
    required super.id,
    required super.email,
    required super.currencyCode,
    required super.customerUrl,
    required super.lineItems,
    required super.name,
    required super.orderNumber,
    required super.processedAt,
    required super.shippingAddress,
    required super.billingAddress,
    required super.statusUrl,
    required super.subtotalPrice,
    required super.totalPrice,
    required super.totalShippingPrice,
    required super.totalTax,
    required super.financialStatus,
    required super.fulfillmentStatus,
    super.totalRefunded,
    super.phone,
    super.cursor,
    super.successfulFulfillments,
  });

  static ShopOrderModel fromShopOrder(Order order) {
    return ShopOrderModel(
      id: order.id,
      email: order.email,
      currencyCode: order.currencyCode,
      customerUrl: order.customerUrl,
      lineItems: ShopLineItemsOrder.fromLineItems(order.lineItems),
      name: order.name,
      orderNumber: order.orderNumber,
      processedAt: order.processedAt,
      shippingAddress:
          ShopShippingAddress.fromShippingAddress(order.shippingAddress),
      billingAddress: order.billingAddress == null
          ? null
          : ShopShippingAddress.fromShippingAddress(order.billingAddress!),
      statusUrl: order.statusUrl,
      subtotalPrice: Price.fromPriceV2(order.subtotalPriceV2),
      totalPrice: Price.fromPriceV2(order.totalPriceV2),
      totalShippingPrice: Price.fromPriceV2(order.totalShippingPriceV2),
      totalTax: Price.fromPriceV2(order.totalTaxV2),
      financialStatus: order.financialStatus,
      fulfillmentStatus: order.fulfillmentStatus,
      totalRefunded: order.totalRefundedV2 == null
          ? null
          : Price.fromPriceV2(order.totalRefundedV2!),
      phone: order.phone,
      cursor: order.cursor,
      successfulFulfillments: order.successfulFulfillments
          ?.map((successfulFullfilment) =>
              ShopSuccessfulFulfilment.fromFulfilment(successfulFullfilment))
          .toList(),
    );
  }
}
