import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/features/checkout/domain/entities/checkout.dart';
import 'package:ecom_template/features/checkout/domain/entities/line_item.dart';
import 'package:ecom_template/features/checkout/domain/entities/shipping_address.dart';

abstract class CheckoutRepository {
  Future<Either<Failure, ShopCheckout>> createCheckout({
    List<ShopLineItem>? lineItems,
    ShopShippingAddress? shippingAddress,
    String? email,
  });

  // Future<ShopCheckout> addLineItemsToCheckout(
  //     {required String checkoutId, required List<ShopLineItem> lineItems});

  // Future<void> checkoutCompleteFree(String checkoutId);

  // Future<String?> checkoutCompleteWithTokenizedPaymentV3(
  //   String checkoutId, {
  //   required ShopifyCheckout checkout,
  //   required String token,
  //   required String paymentTokenType,
  //   required String idempotencyKey,
  //   required String amount,
  //   required String currencyCode,
  // });

  // Future<void> checkoutCustomerAssociate(
  //     String checkoutId, String customerAccessToken);

  // Future<void> checkoutCustomerDisassociate(String checkoutId);

  // Future<ShopCheckout> checkoutDiscountCodeApply(
  //     String checkoutId, String discountCode);

  // Future<void> checkoutDiscountCodeRemove(String checkoutId);

  // Future<void> checkoutGiftCardAppend(
  //     String checkoutId, List<String> giftCardCodes);

  // Future<void> checkoutGiftCardRemove(
  //     String checkoutId, String appliedGiftCardId);

  // Future<void> checkoutLineItemsReplace(
  //     String checkoutId, List<Map<String, dynamic>> variantIdList);

  // Future<ShopCheckout> checkoutShippingLineUpdate(
  //     String checkoutId, String shippingRateHandle);

  // // Future<ShopCheckout> completeCheckoutWithTokenizedPaymentV2({required String checkoutId, required String price, required ShopMailingAddress billingAddress, required String impotencyKey, required ShopTokenizedPaymentInput tokenizedPayment, required String type});

  // Future<List<ShopOrder>?> getAllOrders(String customerAccessToken);

  // Future<ShopCheckout> getCheckoutInfoQuery(String checkoutId);

  // Future<ShopCheckout> removeLineItemsFromCheckout(
  //     {required String checkoutId, required List<ShopLineItem> lineItems});

  // Future<ShopCheckout> shippingAddressUpdate(
  //     String checkoutId, ShopShippingAddress address);

  // Future<void> updateAttributes(String checkoutId);

  // Future<ShopCheckout> updateCheckoutEmail(String checkoutId, String email);

  // Future<ShopCheckout> updateLineItemsInCheckout(
  //     {required String checkoutId, required List<ShopLineItem> lineItems});

  static foobar() {
    // ShopifyCheckout checkout = ShopifyCheckout.instance;
    // checkout.addLineItemsToCheckout(
    //     checkoutId: checkoutId, lineItems: lineItems);
    // checkout.checkForError(queryResult);
    // checkout.checkoutCompleteFree(checkoutId);
    // checkout.checkoutCompleteWithTokenizedPaymentV3(checkoutId,
    //     checkout: checkout,
    //     token: token,
    //     paymentTokenType: paymentTokenType,
    //     idempotencyKey: idempotencyKey,
    //     amount: amount,
    //     currencyCode: currencyCode,);
    // checkout.checkoutCustomerAssociate(checkoutId, customerAccessToken)
    // checkout.checkoutCustomerDisassociate(checkoutId);
    // checkout.checkoutDiscountCodeApply(checkoutId, discountCode);
    // checkout.checkoutDiscountCodeRemove(checkoutId);
    // checkout.checkoutGiftCardAppend(checkoutId, giftCardCodes);
    // checkout.checkoutGiftCardRemove(checkoutId, appliedGiftCardId);
    // checkout.checkoutLineItemsReplace(checkoutId, variantIdList);
    // checkout.checkoutShippingLineUpdate(checkoutId, shippingRateHandle)
    // checkout.completeCheckoutWithTokenizedPaymentV2(checkoutId: checkoutId, price: price, billingAddress: billingAddress, impotencyKey: impotencyKey, tokenizedPayment: tokenizedPayment, type: type);
    // checkout.createCheckout(checkoutInput);
    // checkout.getAllOrders(customerAccessToken);
    // checkout.getCheckoutInfoQuery(checkoutId);
    // checkout.removeLineItemsFromCheckout(checkoutId: checkoutId, lineItems: lineItems);
    // checkout.shippingAddressUpdate(checkoutId, address);
    // checkout.updateAttributes(checkoutId);
    // checkout.updateCheckoutEmail(checkoutId, email);
    // checkout.updateLineItemsInCheckout(checkoutId: checkoutId, lineItems: lineItems);
  }
}
