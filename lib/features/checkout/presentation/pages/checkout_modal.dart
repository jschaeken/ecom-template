import 'dart:developer';

import 'package:ecom_template/features/checkout/presentation/pages/checkout_page.dart';
import 'package:ecom_template/features/order/domain/entities/order_completion.dart';
import 'package:flutter/material.dart';

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
      OrderCompletion? orderCompletion =
          await _showCheckoutModal(context, widget.checkout);
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

Future<OrderCompletion?> _showCheckoutModal(
    BuildContext context, ShopCheckout checkout) async {
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
        child: CheckoutIncompleteSheet(
          onOrderPlacementAttempt: (orderCompletion) {
            Navigator.of(context).pop<OrderCompletion>(orderCompletion);
          },
          checkout: checkout,
        ),
      );
    },
  );
}
