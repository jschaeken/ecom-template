import 'package:flutter/material.dart';

class CheckoutCompleteDialogue extends StatefulWidget {
  final String orderId;

  const CheckoutCompleteDialogue({required this.orderId, Key? key})
      : super(key: key);

  @override
  State<CheckoutCompleteDialogue> createState() =>
      _CheckoutCompleteDialogueState();
}

class _CheckoutCompleteDialogueState extends State<CheckoutCompleteDialogue> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _showConfirmationPopUp(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox.shrink(),
    );
  }

  _showConfirmationPopUp(String orderId) async {
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
}
