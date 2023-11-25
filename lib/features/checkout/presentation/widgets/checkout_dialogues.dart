import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:ecom_template/features/order/presentation/pages/orders_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showOrderCompletedConfirmationPopUp(
    BuildContext context, String orderId) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const TextBody(
          text: 'Order Placed',
          fontWeight: FontWeight.bold,
        ),
        content: TextBody(text: 'Your order${' $orderId'} has been placed'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                CupertinoPageRoute(builder: (context) => const OrdersPage()),
              );
            },
            child: const TextBody(text: 'View Order'),
          ),
        ],
      );
    },
  );
}

showOrderErrorDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const TextBody(text: 'Order Error'),
        content: const TextBody(text: 'There was an error placing your order'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const TextBody(text: 'OK'),
          ),
        ],
      );
    },
  );
}
