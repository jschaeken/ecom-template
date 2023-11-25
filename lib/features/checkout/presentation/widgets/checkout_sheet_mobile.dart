import 'dart:developer';

import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/widgets/layout.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:ecom_template/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:ecom_template/features/checkout/presentation/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'checkout_field.dart';

class CheckoutSheetMobile extends StatelessWidget {
  const CheckoutSheetMobile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      builder: (context, checkoutState) {
        if (checkoutState is CheckoutLoaded) {
          log('webUrl: ${checkoutState.checkout}');
        }
        return Column(
          mainAxisSize: MainAxisSize.max,
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
                    // Errors
                    if (checkoutState is CheckoutLoaded)
                      if (checkoutState.userErrors.isNotEmpty)
                        Padding(
                          padding: Constants.padding,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: double.infinity,
                              ),
                              for (var error in checkoutState.userErrors)
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: Constants.borderRadius,
                                    color: const Color.fromARGB(
                                        255, 255, 207, 204),
                                  ),
                                  child: Padding(
                                    padding: Constants.padding,
                                    child: TextBody(
                                      text: error.message,
                                      maxLines: 3,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              const StandardSpacing(),
                            ],
                          ),
                        ),

                    // Items
                    checkoutState is CheckoutLoaded
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: double.infinity,
                              ),
                              Padding(
                                padding: Constants.padding,
                                child: TextSubHeadline(
                                  text:
                                      '${checkoutState.checkout.lineItems.length} Items',
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
                                  itemCount:
                                      checkoutState.checkout.lineItems.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: Constants.innerPadding.copyWith(
                                        left: index != 0
                                            ? Constants.innerPadding.left
                                            : Constants.padding.left,
                                      ),
                                      child: (checkoutState
                                                      .checkout
                                                      .lineItems[index]
                                                      .variant
                                                      ?.product
                                                      ?.images !=
                                                  null) &&
                                              (checkoutState
                                                  .checkout
                                                  .lineItems[index]
                                                  .variant!
                                                  .product!
                                                  .images
                                                  .isNotEmpty)
                                          ? Stack(
                                              children: [
                                                Image.network(
                                                  checkoutState
                                                      .checkout
                                                      .lineItems[index]
                                                      .variant!
                                                      .product!
                                                      .images
                                                      .first
                                                      .originalSrc,
                                                  width: 100,
                                                  height: 120,
                                                  fit: BoxFit.cover,
                                                ),
                                                Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: TextBody(
                                                      text:
                                                          '${checkoutState.checkout.lineItems[index].quantity}',
                                                      color: Theme.of(context)
                                                          .canvasColor,
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
                            ],
                          )
                        : const SizedBox(
                            height: 120,
                            child: CircularProgressIndicator(),
                          ),
                    if (checkoutState is CheckoutLoaded)
                      Padding(
                        padding: Constants.padding.copyWith(bottom: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: Constants.innerPadding
                                  .copyWith(left: 0, right: 0),
                              child: const Divider(),
                            ),
                            // Email
                            CheckoutField(
                              title: 'Email Address',
                              subtitle: checkoutState.checkout.email ?? '',
                              onTapped: () {
                                debugPrint('Email');
                              },
                            ),
                            // Shipping Address
                            CheckoutField(
                              title: 'Shipping Address',
                              subtitle:
                                  '${checkoutState.checkout.shippingAddress?.address1}, ${checkoutState.checkout.shippingAddress?.city}, ${checkoutState.checkout.shippingAddress?.province}, ${checkoutState.checkout.shippingAddress?.zip}, ${checkoutState.checkout.shippingAddress?.country}',
                              onTapped: () {
                                debugPrint('Shipping Address');
                              },
                            ),
                            // Shipping Method
                            CheckoutField(
                              title: 'Shipping Method',
                              subtitle: checkoutState
                                      .checkout.shippingLine?.first.title ??
                                  'Free',
                              onTapped: () {
                                debugPrint('Shipping Method');
                              },
                            ),
                            // Gift Card or Discount Code
                            CheckoutField(
                              title: 'Gift Card or Discount Code',
                              // show total balance of gift cards applied
                              subtitle: '',
                              leading: checkoutState
                                              .checkout.discountCodesApplied !=
                                          null &&
                                      checkoutState.checkout
                                          .discountCodesApplied!.isNotEmpty
                                  ? Padding(
                                      padding: Constants.innerPadding
                                          .copyWith(left: 0, right: 0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: Constants.borderRadius,
                                          color: Theme.of(context).cardColor,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Row(
                                            children: [
                                              TextBody(
                                                text: checkoutState
                                                    .checkout
                                                    .discountCodesApplied!
                                                    .first,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  BlocProvider.of<CheckoutBloc>(
                                                          context)
                                                      .add(
                                                    RemoveDiscountCodeEvent(
                                                      checkout: checkoutState
                                                          .checkout,
                                                      discountCode: checkoutState
                                                          .checkout
                                                          .discountCodesApplied!
                                                          .first,
                                                    ),
                                                  );
                                                },
                                                child: Icon(
                                                  Icons.close,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  size: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : null,
                              onTapped: () async {
                                final resp =
                                    await _showAddDiscountDiscountDialogue(
                                        context);
                                if (resp != null && context.mounted) {
                                  BlocProvider.of<CheckoutBloc>(context).add(
                                    AddDiscountCodeEvent(
                                      checkout: checkoutState.checkout,
                                      discountCode: resp,
                                    ),
                                  );
                                }
                              },
                            ),

                            // Padding(
                            //   padding:
                            //       Constants.innerPadding.copyWith(left: 0, right: 0),
                            //   child: const Divider(),
                            // ),
                          ],
                        ),
                      ),

                    // SubTotal, Shipping, Taxes, Total
                    if (checkoutState is CheckoutLoaded)
                      Padding(
                        padding: Constants.padding.copyWith(top: 0),
                        child: Column(
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
                                    text: checkoutState.checkout.subtotalPrice
                                        .formattedPrice(),
                                    color:
                                        Theme.of(context).unselectedWidgetColor,
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
                                    text: checkoutState
                                            .checkout.shippingLine?.first.price
                                            .formattedPrice() ??
                                        'Free',
                                    color:
                                        Theme.of(context).unselectedWidgetColor,
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
                                      text: 'Discounts',
                                      color: Theme.of(context)
                                          .unselectedWidgetColor),
                                  TextBody(
                                    text: checkoutState
                                            .checkout.totalDiscountApplied
                                            ?.formattedPrice() ??
                                        '0.00',
                                    color:
                                        Theme.of(context).unselectedWidgetColor,
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
                                    text: checkoutState.checkout.totalPrice
                                        .formattedPrice(),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                  ],
                ),
              ),
            ),
            if (checkoutState is CheckoutLoaded)
              // Payment Buttons
              Column(
                children: [
                  // Apple Pay / Google Pay
                  ApplePayButton(
                    onTap: () {
                      debugPrint('Apple Pay Demo Completed Order');
                      // onOrderPlacementAttempt(
                      //   OrderCompletion(
                      //     status: OrderCompletionStatus.completed,
                      //     checkoutId: checkoutState.checkout.id,
                      //     orderId: 'demoOrderId',
                      //   ),
                      // );
                    },
                  ),

                  const StandardSpacing(
                    multiplier: 1,
                  ),

                  // Continue to Web Payment
                  const StandardSpacing(
                    multiplier: 1,
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}

Future<String?> _showAddDiscountDiscountDialogue(BuildContext context) async {
  FocusNode focus = FocusNode();
  TextEditingController controller = TextEditingController();

  return await showDialog(
    context: context,
    builder: (context) {
      focus.requestFocus();
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              cursorColor: Theme.of(context).primaryColor,
              focusNode: focus,
              controller: controller,
              decoration: InputDecoration(
                fillColor: Theme.of(context).canvasColor,
                hoverColor: Theme.of(context).unselectedWidgetColor,
                hintText: 'Enter Discount Code',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const TextBody(text: 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(controller.text);
            },
            child: const TextBody(text: 'Apply', fontWeight: FontWeight.bold),
          ),
        ],
      );
    },
  );
}
