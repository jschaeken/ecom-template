import 'package:ecom_template/features/order/domain/entities/line_item_order.dart';
import 'package:equatable/equatable.dart';
import 'package:shopify_flutter/models/src/order/line_items_order/line_items_order.dart';

class ShopLineItemsOrder extends Equatable {
  final List<ShopLineItemOrder> lineItemOrderList;

  const ShopLineItemsOrder({required this.lineItemOrderList});

  @override
  List<Object?> get props => [lineItemOrderList];

  static ShopLineItemsOrder fromLineItems(LineItemsOrder lineItems) {
    return ShopLineItemsOrder(
      lineItemOrderList: lineItems.lineItemOrderList
          .map((lineItemOrder) =>
              ShopLineItemOrder.fromLineItemOrder(lineItemOrder))
          .toList(),
    );
  }
}
