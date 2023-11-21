import 'package:flutter/material.dart';

showOrderCompletedConfirmationPopUp(
    BuildContext context, String orderId) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Order Placed'),
        content: Text('Your order $orderId has been completed'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
