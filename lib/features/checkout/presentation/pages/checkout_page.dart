import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/widgets/icon_components.dart';
import 'package:ecom_template/core/presentation/widgets/layout.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:ecom_template/features/checkout/domain/entities/checkout.dart';
import 'package:ecom_template/features/checkout/presentation/pages/webview_modal.dart';
import 'package:ecom_template/features/order/domain/entities/order_completion.dart';
import 'package:flutter/material.dart';
import 'package:ecom_template/core/presentation/widgets/buttons.dart'
    as buttons;

class CheckoutIncompleteSheet extends StatelessWidget {
  final Function(OrderCompletion orderCompletion) onOrderPlacementAttempt;
  final ShopCheckout checkout;

  const CheckoutIncompleteSheet({
    required this.onOrderPlacementAttempt,
    required this.checkout,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: double.infinity,
                ),
                const TextHeadline(text: 'CHECKOUT'),
                const StandardSpacing(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: Constants.padding,
                      child: TextSubHeadline(
                        text: '${checkout.lineItems.length} Items',
                      ),
                    ),
                    // Items Image Scroller
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(0),
                        itemCount: checkout.lineItems.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: Constants.innerPadding.copyWith(
                              left: index != 0
                                  ? Constants.innerPadding.left
                                  : Constants.padding.left,
                            ),
                            child: (checkout.lineItems[index].variant?.product
                                            ?.images !=
                                        null) &&
                                    (checkout.lineItems[index].variant!.product!
                                        .images.isNotEmpty)
                                ? Stack(
                                    children: [
                                      Image.network(
                                        checkout.lineItems[index].variant!
                                            .product!.images.first.originalSrc,
                                        width: 100,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: TextBody(
                                            text:
                                                '${checkout.lineItems[index].quantity}',
                                            color:
                                                Theme.of(context).canvasColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Image.asset(
                                    'assets/images/placeholder-image.png',
                                    width: 100,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                          );
                        },
                      ),
                    ),
                    // Details Column
                    Padding(
                      padding: Constants.padding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Email
                          Padding(
                            padding: Constants.innerPadding
                                .copyWith(left: 0, right: 0),
                            child: const Divider(),
                          ),
                          const TextSubHeadline(text: 'Email Address'),
                          TextBody(
                            text: checkout.email ?? 'Enter Email Address',
                            color: Theme.of(context).unselectedWidgetColor,
                          ),
                          Padding(
                            padding: Constants.innerPadding
                                .copyWith(left: 0, right: 0),
                            child: const Divider(),
                          ),
                          // Shipping Address
                          const TextSubHeadline(text: 'Shipping Address'),
                          TextBody(
                            text:
                                '${checkout.shippingAddress?.address1}, ${checkout.shippingAddress?.city}, ${checkout.shippingAddress?.province}, ${checkout.shippingAddress?.zip}, ${checkout.shippingAddress?.country}',
                            maxLines: 1,
                            color: Theme.of(context).unselectedWidgetColor,
                          ),
                          Padding(
                            padding: Constants.innerPadding
                                .copyWith(left: 0, right: 0),
                            child: const Divider(),
                          ),

                          // Shipping Method
                          GestureDetector(
                            onTap: () {
                              debugPrint('Shipping Method');
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: double.infinity,
                                  ),
                                  const TextSubHeadline(
                                      text: 'Shipping Method'),
                                  TextBody(
                                    text:
                                        '${checkout.shippingLine?.first.title}',
                                    color:
                                        Theme.of(context).unselectedWidgetColor,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Padding(
                            padding: Constants.innerPadding
                                .copyWith(left: 0, right: 0),
                            child: const Divider(),
                          ),

                          // Gift Card or Discount Code
                          GestureDetector(
                            onTap: () {
                              debugPrint('Gift Card or Discount Code');
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: double.infinity,
                                  ),
                                  const TextSubHeadline(
                                      text: 'Gift Card or Discount Code'),
                                  TextBody(
                                    text:
                                        'TODO: Implement Gift Card or Discount Code',
                                    color:
                                        Theme.of(context).unselectedWidgetColor,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Padding(
                            padding: Constants.innerPadding
                                .copyWith(left: 0, right: 0),
                            child: const Divider(),
                          ),

                          // SubTotal, Shipping, Taxes, Total
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: Constants.innerPadding
                                    .copyWith(left: 0, right: 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextBody(
                                        text: 'Subtotal',
                                        color: Theme.of(context)
                                            .unselectedWidgetColor),
                                    TextBody(
                                      text: checkout.subtotalPrice
                                          .formattedPrice(),
                                      color: Theme.of(context)
                                          .unselectedWidgetColor,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: Constants.innerPadding
                                    .copyWith(left: 0, right: 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextBody(
                                        text: 'Shipping',
                                        color: Theme.of(context)
                                            .unselectedWidgetColor),
                                    TextBody(
                                      text: checkout.shippingLine?.first.price
                                              .formattedPrice() ??
                                          'Free',
                                      color: Theme.of(context)
                                          .unselectedWidgetColor,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: Constants.innerPadding
                                    .copyWith(left: 0, right: 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextBody(
                                        text: 'Taxes',
                                        color: Theme.of(context)
                                            .unselectedWidgetColor),
                                    TextBody(
                                      text: checkout.totalTax.formattedPrice(),
                                      color: Theme.of(context)
                                          .unselectedWidgetColor,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: Constants.innerPadding
                                    .copyWith(left: 0, right: 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const TextHeadline(text: 'Total'),
                                    TextHeadline(
                                      text:
                                          checkout.totalPrice.formattedPrice(),
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Column(
          children: [
            // Apple Pay / Google Pay
            ApplePayButton(
              onTap: () {
                debugPrint('Apple Pay Demo Completed Order');
                onOrderPlacementAttempt(
                  OrderCompletion(
                    status: OrderCompletionStatus.completed,
                    checkoutId: checkout.id,
                    orderId: 'demoOrderId',
                  ),
                );
              },
            ),

            const StandardSpacing(
              multiplier: 1,
            ),

            // Continue to Web Payment
            checkout.webUrl != null
                ? ContinueToPaymentButton(onTap: () async {
                    bool? didCompletePayment = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return WebViewPage(
                            url: checkout.webUrl!,
                            title: 'Payment',
                          );
                        },
                      ),
                    );
                    if (didCompletePayment != null && didCompletePayment) {
                      debugPrint('did complete payment');
                      if (context.mounted) {
                        onOrderPlacementAttempt(
                          OrderCompletion(
                            status: OrderCompletionStatus.completed,
                            checkoutId: checkout.id,
                            orderId: checkout.order!.id,
                          ),
                        );
                      }
                    } else {
                      if (context.mounted) {
                        onOrderPlacementAttempt(
                          OrderCompletion(
                            status: OrderCompletionStatus.notCompleted,
                            checkoutId: checkout.id,
                            orderId: null,
                          ),
                        );
                      }
                    }
                  })
                : const SizedBox.shrink(),
            const StandardSpacing(
              multiplier: 3,
            ),
          ],
        ),
      ],
    );
  }
}

class ContinueToPaymentButton extends StatelessWidget {
  const ContinueToPaymentButton({
    required this.onTap,
    super.key,
  });

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Constants.padding.copyWith(top: 0, bottom: 0),
      child: buttons.CtaButton(
        height: 50,
        width: double.infinity,
        color: Theme.of(context).indicatorColor,
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextHeadline(
              text: 'Continue To Payment',
              color: Theme.of(context).canvasColor,
            ),
          ],
        ),
      ),
    );
  }
}

class ApplePayButton extends StatelessWidget {
  const ApplePayButton({
    required this.onTap,
    super.key,
  });

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Constants.padding.copyWith(top: 0, bottom: 0),
      child: buttons.CtaButton(
        height: 50,
        width: double.infinity,
        color: Theme.of(context).primaryColor,
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIcon(
              Icons.apple,
              color: Theme.of(context).canvasColor,
            ),
            const SizedBox(
              width: 5,
            ),
            TextHeadline(
              text: 'Pay',
              color: Theme.of(context).canvasColor,
            ),
          ],
        ),
      ),
    );
  }
}
