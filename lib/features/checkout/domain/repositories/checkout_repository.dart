import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/features/checkout/domain/entities/checkout.dart';
import 'package:ecom_template/features/checkout/domain/entities/line_item.dart';
import 'package:ecom_template/features/checkout/domain/entities/shipping_address.dart';

abstract class CheckoutRepository {
  Future<Either<Failure, ShopCheckout>> createCheckout({
    List<ShopLineItem>? lineItems,
    ShopShippingAddress? shippingAddress,
    String? email,
  });

  Future<Either<Failure, ShopCheckout>> getCheckoutById({
    required String checkoutId,
  });

  Future<Either<Failure, ShopCheckout>> addDiscountCode({
    required String checkoutId,
    required String discountCode,
  });

  Future<Either<Failure, WriteSuccess>> removeDiscountCode({
    required String checkoutId,
    required String discountCode,
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

  // Future<ShopCheckout> removeLineItemsFromCheckout(
  //     {required String checkoutId, required List<ShopLineItem> lineItems});

  // Future<ShopCheckout> shippingAddressUpdate(
  //     String checkoutId, ShopShippingAddress address);

  // Future<void> updateAttributes(String checkoutId);

  // Future<ShopCheckout> updateCheckoutEmail(String checkoutId, String email);

  // Future<ShopCheckout> updateLineItemsInCheckout(
  //     {required String checkoutId, required List<ShopLineItem> lineItems});
}
