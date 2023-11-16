import 'package:ecom_template/features/checkout/domain/entities/checkout.dart';
import 'package:ecom_template/features/checkout/domain/entities/line_item.dart';
import 'package:ecom_template/features/checkout/domain/entities/shipping_address.dart';
import 'package:ecom_template/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:ecom_template/features/order/domain/entities/order.dart';
import 'package:shopify_flutter/shopify/src/shopify_checkout.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  @override
  Future<ShopCheckout> createCheckout(List<ShopLineItem>? lineItems,
      ShopShippingAddress? shippingAddress, String? email) {
    // TODO: implement createCheckout
    throw UnimplementedError();
  }

  @override
  Future<ShopCheckout> addLineItemsToCheckout(
      {required String checkoutId, required List<ShopLineItem> lineItems}) {
    // TODO: implement addLineItemsToCheckout
    throw UnimplementedError();
  }

  @override
  Future<void> checkoutCompleteFree(String checkoutId) {
    // TODO: implement checkoutCompleteFree
    throw UnimplementedError();
  }

  @override
  Future<String?> checkoutCompleteWithTokenizedPaymentV3(String checkoutId,
      {required ShopifyCheckout checkout,
      required String token,
      required String paymentTokenType,
      required String idempotencyKey,
      required String amount,
      required String currencyCode}) {
    // TODO: implement checkoutCompleteWithTokenizedPaymentV3
    throw UnimplementedError();
  }

  @override
  Future<void> checkoutCustomerAssociate(
      String checkoutId, String customerAccessToken) {
    // TODO: implement checkoutCustomerAssociate
    throw UnimplementedError();
  }

  @override
  Future<void> checkoutCustomerDisassociate(String checkoutId) {
    // TODO: implement checkoutCustomerDisassociate
    throw UnimplementedError();
  }

  @override
  Future<ShopCheckout> checkoutDiscountCodeApply(
      String checkoutId, String discountCode) {
    // TODO: implement checkoutDiscountCodeApply
    throw UnimplementedError();
  }

  @override
  Future<void> checkoutDiscountCodeRemove(String checkoutId) {
    // TODO: implement checkoutDiscountCodeRemove
    throw UnimplementedError();
  }

  @override
  Future<void> checkoutGiftCardAppend(
      String checkoutId, List<String> giftCardCodes) {
    // TODO: implement checkoutGiftCardAppend
    throw UnimplementedError();
  }

  @override
  Future<void> checkoutGiftCardRemove(
      String checkoutId, String appliedGiftCardId) {
    // TODO: implement checkoutGiftCardRemove
    throw UnimplementedError();
  }

  @override
  Future<void> checkoutLineItemsReplace(
      String checkoutId, List<Map<String, dynamic>> variantIdList) {
    // TODO: implement checkoutLineItemsReplace
    throw UnimplementedError();
  }

  @override
  Future<ShopCheckout> checkoutShippingLineUpdate(
      String checkoutId, String shippingRateHandle) {
    // TODO: implement checkoutShippingLineUpdate
    throw UnimplementedError();
  }

  @override
  Future<List<ShopOrder>?> getAllOrders(String customerAccessToken) {
    // TODO: implement getAllOrders
    throw UnimplementedError();
  }

  @override
  Future<ShopCheckout> getCheckoutInfoQuery(String checkoutId) {
    // TODO: implement getCheckoutInfoQuery
    throw UnimplementedError();
  }

  @override
  Future<ShopCheckout> removeLineItemsFromCheckout(
      {required String checkoutId, required List<ShopLineItem> lineItems}) {
    // TODO: implement removeLineItemsFromCheckout
    throw UnimplementedError();
  }

  @override
  Future<ShopCheckout> shippingAddressUpdate(
      String checkoutId, ShopShippingAddress address) {
    // TODO: implement shippingAddressUpdate
    throw UnimplementedError();
  }

  @override
  Future<void> updateAttributes(String checkoutId) {
    // TODO: implement updateAttributes
    throw UnimplementedError();
  }

  @override
  Future<ShopCheckout> updateCheckoutEmail(String checkoutId, String email) {
    // TODO: implement updateCheckoutEmail
    throw UnimplementedError();
  }

  @override
  Future<ShopCheckout> updateLineItemsInCheckout(
      {required String checkoutId, required List<ShopLineItem> lineItems}) {
    // TODO: implement updateLineItemsInCheckout
    throw UnimplementedError();
  }
}
