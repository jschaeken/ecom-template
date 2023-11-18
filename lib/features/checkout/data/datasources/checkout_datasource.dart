import 'package:ecom_template/features/checkout/data/models/checkout_model.dart';
import 'package:shopify_flutter/models/src/checkout/line_item/line_item.dart';
import 'package:shopify_flutter/models/src/shopify_user/address/address.dart';
import 'package:shopify_flutter/shopify/src/shopify_checkout.dart';

abstract class CheckoutDataSource {
  /// Creates a new checkout with the shopify_flutter package
  /// Calls the shopify_flutter package
  Future<ShopCheckoutModel> createCheckout({
    List<LineItem>? lineItems,
    Address? shippingAddress,
    String? email,
  });
}

class CheckoutDataSourceImpl implements CheckoutDataSource {
  final ShopifyCheckout shopifyCheckout;

  CheckoutDataSourceImpl({required this.shopifyCheckout});

  @override
  Future<ShopCheckoutModel> createCheckout(
      {List<LineItem>? lineItems,
      Address? shippingAddress,
      String? email}) async {
    final response = await shopifyCheckout.createCheckout(
        lineItems: lineItems, shippingAddress: shippingAddress, email: email);
    return ShopCheckoutModel.fromShopifyCheckout(response);
  }
}
