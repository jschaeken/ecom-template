import 'package:ecom_template/features/checkout/domain/entities/line_item.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:equatable/equatable.dart';
import 'package:shopify_flutter/models/src/shopify_user/last_incomplete_checkout/last_incomplete_checkout.dart';

class ShopLastIncompleteCheckout extends Equatable {
  final String? completedAt;
  final String? createdAt;
  final String? email;
  final String? id;
  final String? currencyCode;
  final String? webUrl;
  final Price? totalPriceV2;
  final Price? lineItemsSubtotalPrice;
  final List<ShopLineItem>? lineItems;

  const ShopLastIncompleteCheckout({
    this.completedAt,
    this.createdAt,
    this.currencyCode,
    this.email,
    this.id,
    this.lineItems,
    this.lineItemsSubtotalPrice,
    this.totalPriceV2,
    this.webUrl,
  });

  @override
  List<Object?> get props => [
        completedAt,
        createdAt,
        currencyCode,
        email,
        id,
        lineItems,
        lineItemsSubtotalPrice,
        totalPriceV2,
        webUrl,
      ];

  static ShopLastIncompleteCheckout? fromLastIncompleteCheckout(
      LastIncompleteCheckout? lastIncompleteCheckout) {
    if (lastIncompleteCheckout == null) {
      return null;
    }
    return ShopLastIncompleteCheckout(
      completedAt: lastIncompleteCheckout.completedAt,
      createdAt: lastIncompleteCheckout.createdAt,
      currencyCode: lastIncompleteCheckout.currencyCode,
      email: lastIncompleteCheckout.email,
      id: lastIncompleteCheckout.id,
      lineItems: lastIncompleteCheckout.lineItems?.map((lineItem) {
        return ShopLineItem.fromLineItem(lineItem);
      }).toList(),
      lineItemsSubtotalPrice: lastIncompleteCheckout.lineItemsSubtotalPrice !=
              null
          ? Price.fromPriceV2(lastIncompleteCheckout.lineItemsSubtotalPrice!)
          : null,
      totalPriceV2: lastIncompleteCheckout.totalPriceV2 != null
          ? Price.fromPriceV2(lastIncompleteCheckout.totalPriceV2!)
          : null,
      webUrl: lastIncompleteCheckout.webUrl,
    );
  }
}
