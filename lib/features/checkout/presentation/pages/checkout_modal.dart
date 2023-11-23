import 'dart:developer';

import 'package:ecom_template/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:ecom_template/features/checkout/presentation/pages/checkout_page.dart';
import 'package:ecom_template/features/order/domain/entities/order_completion.dart';
import 'package:ecom_template/features/shop/presentation/widgets/state_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/checkout.dart';

class IncompleteCheckoutModal extends StatefulWidget {
  final Function(OrderCompletion orderCompletion) onCompleted;
  final ShopCheckout checkout;

  const IncompleteCheckoutModal(
      {required this.onCompleted, required this.checkout, Key? key})
      : super(key: key);

  @override
  State<IncompleteCheckoutModal> createState() =>
      _IncompleteCheckoutModalState();
}

class _IncompleteCheckoutModalState extends State<IncompleteCheckoutModal> {
  @override
  void initState() {
    super.initState();
    // postframe callback
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      OrderCompletion? orderCompletion = await _showCheckoutModal(context);
      log('Order Completion in checkout modal: $orderCompletion');
      if (orderCompletion != null) {
        widget.onCompleted(orderCompletion);
      } else {
        widget.onCompleted(
          OrderCompletion(
            status: OrderCompletionStatus.notCompleted,
            checkoutId: widget.checkout.id,
            orderId: null,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

Future<OrderCompletion?> _showCheckoutModal(BuildContext context) async {
  return await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    showDragHandle: true,
    anchorPoint: const Offset(0.5, 0.5),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    builder: (context) {
      return SizedBox(
        height: 600,
        child: BlocBuilder<CheckoutBloc, CheckoutState>(
          builder: (context, checkoutState) {
            if (checkoutState is CheckoutLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (checkoutState is CheckoutError) {
              return Center(
                child: IconTextError(
                  failure: checkoutState.failure,
                ),
              );
            }
            if (checkoutState is CheckoutLoaded) {
              return const CheckoutIncompleteSheet(
                  // onDiscountCodeApplication: (discountCode) {
                  //   BlocProvider.of<CheckoutBloc>(context, listen: false).add(
                  //     AddDiscountCodeEvent(
                  //       discountCode: discountCode,
                  //       checkoutId: checkoutState.checkout.id,
                  //     ),
                  //   );
                  // },
                  // onOrderPlacementAttempt: (orderCompletion) {
                  //   Navigator.of(context).pop<OrderCompletion>(orderCompletion);
                  // },
                  );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      );
    },
  );
}
