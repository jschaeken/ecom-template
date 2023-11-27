import 'package:ecom_template/core/error/exceptions.dart';
import 'package:ecom_template/features/order/data/models/order_model.dart';
import 'package:shopify_flutter/models/src/order/order.dart';
import 'package:shopify_flutter/shopify/shopify.dart';

abstract class OrdersRemoteDataSource {
  Future<List<ShopOrderModel>> getAllOrders(String customerAccessToken);
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final ShopifyCheckout shopifyCheckout;

  OrdersRemoteDataSourceImpl({
    required this.shopifyCheckout,
  });

  @override
  Future<List<ShopOrderModel>> getAllOrders(String customerAccessToken) async {
    final response = await shopifyCheckout.getAllOrders(customerAccessToken);
    if (response == null) {
      throw ServerException();
    }
    List<ShopOrderModel> orders = [];
    for (final Order order in response) {
      orders.add(ShopOrderModel.fromShopOrder(order));
    }
    return orders;
  }
}
