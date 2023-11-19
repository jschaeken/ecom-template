import 'dart:developer';

import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/widgets/icon_components.dart';
import 'package:ecom_template/core/presentation/widgets/layout.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:ecom_template/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecom_template/core/presentation/widgets/buttons.dart'
    as buttons;

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Constants.padding,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: double.infinity,
                  ),
                  const Row(
                    children: [
                      TextHeadline(text: 'Checkout'),
                    ],
                  ),
                  const StandardSpacing(),
                  BlocBuilder<CheckoutBloc, CheckoutState>(
                    builder: (context, checkoutState) {
                      switch (checkoutState.runtimeType) {
                        case CheckoutInitial:
                          return const TextBody(text: 'Initial');
                        case CheckoutLoading:
                          return CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          );
                        case CheckoutLoaded:
                          checkoutState as CheckoutLoaded;
                          log(checkoutState.checkout.toString());
                          return Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    checkoutState.checkout.lineItems.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        checkoutState.checkout.lineItems[index]
                                            .variant!.image!.originalSrc,
                                        height: 100,
                                        width: 100,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextBody(
                                              text: checkoutState.checkout
                                                  .lineItems[index].title),
                                          TextBody(
                                              text: checkoutState.checkout
                                                  .lineItems[index].quantity
                                                  .toString()),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                              const StandardSpacing(),
                              // SubTotals, discounts, taxes, shipping, total
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const TextSubHeadline(text: 'Subtotal'),
                                  TextSubHeadline(
                                      text: checkoutState.checkout.subtotalPrice
                                          .formattedPrice()),
                                ],
                              ),
                              Builder(
                                builder: (context) => checkoutState
                                        .checkout.appliedGiftCards.isNotEmpty
                                    ? Column(
                                        children: [
                                          const StandardSpacing(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const TextSubHeadline(
                                                  text: 'Discounts'),
                                              TextSubHeadline(
                                                  text: checkoutState
                                                      .checkout
                                                      .appliedGiftCards
                                                      .first
                                                      .amountUsed
                                                      .formattedPrice()),
                                            ],
                                          ),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          );
                        case CheckoutError:
                          return const TextBody(text: 'Error');
                        default:
                          return const TextBody(text: 'Default');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          buttons.CtaButton(
            height: 50,
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomIcon(
                  Icons.apple,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 5,
                ),
                TextSubHeadline(
                  text: 'Pay',
                  color: Theme.of(context).canvasColor,
                ),
              ],
            ),
          ),
          const StandardSpacing(
            multiplier: 2,
          ),
        ],
      ),
    );
  }
}
