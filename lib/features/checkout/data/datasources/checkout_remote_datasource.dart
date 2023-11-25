import 'dart:developer';

import 'package:ecom_template/features/checkout/data/models/checkout_model.dart';
import 'package:shopify_flutter/models/src/checkout/line_item/line_item.dart';
import 'package:shopify_flutter/models/src/shopify_user/address/address.dart';
import 'package:shopify_flutter/shopify/src/shopify_checkout.dart';

abstract class CheckoutRemoteDataSource {
  /// Creates a new checkout with the shopify_flutter package
  /// Calls the shopify_flutter package
  Future<ShopCheckoutModel> createCheckout({
    List<LineItem>? lineItems,
    Address? shippingAddress,
    String? email,
  });

  /// Gets the checkout info from the shopify_flutter package
  /// Calls the shopify_flutter package
  Future<ShopCheckoutModel> getCheckoutInfo({required String checkoutId});

  /// Adds a discount code to the checkout
  /// Calls the shopify_flutter package
  Future<ShopCheckoutModel> addDiscountCode({
    required String checkoutId,
    required String discountCode,
  });

  /// Removes a discount code from the checkout
  /// Calls the shopify_flutter package
  Future<void> removeDiscountCode({
    required String checkoutId,
    required String discountCode,
  });
}

class CheckoutRemoteDataSourceImpl implements CheckoutRemoteDataSource {
  final ShopifyCheckout shopifyCheckout;

  CheckoutRemoteDataSourceImpl({required this.shopifyCheckout});

  @override
  Future<ShopCheckoutModel> createCheckout({
    List<LineItem>? lineItems,
    Address? shippingAddress,
    String? email,
  }) async {
    final response = await shopifyCheckout.createCheckout(
        lineItems: lineItems, shippingAddress: shippingAddress, email: email);
    return ShopCheckoutModel.fromShopifyCheckout(response);
  }

  @override
  Future<ShopCheckoutModel> getCheckoutInfo(
      {required String checkoutId}) async {
    final response = await shopifyCheckout.getCheckoutInfoQuery(checkoutId);
    log('checkoutInfo: $response');
    return ShopCheckoutModel.fromShopifyCheckout(response);
  }

  @override
  Future<ShopCheckoutModel> addDiscountCode({
    required String checkoutId,
    required String discountCode,
  }) async {
    final response = await shopifyCheckout.checkoutDiscountCodeApply(
      checkoutId,
      discountCode,
    );
    return ShopCheckoutModel.fromShopifyCheckout(response);
  }

  @override
  Future<void> removeDiscountCode({
    required String checkoutId,
    required String discountCode,
  }) async {
    await shopifyCheckout.checkoutDiscountCodeRemove(
      checkoutId,
    );
    return;
  }
}
