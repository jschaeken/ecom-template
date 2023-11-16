import 'package:ecom_template/features/order/domain/entities/line_item_order.dart';
import 'package:equatable/equatable.dart';

class ShopLineItemsOrder extends Equatable {
  final List<ShopLineItemOrder> lineItemOrderList;

  const ShopLineItemsOrder({required this.lineItemOrderList});

  @override
  List<Object?> get props => [lineItemOrderList];
}
