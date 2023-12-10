import 'package:ecom_template/features/checkout/presentation/widgets/checkout_sheet_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WebCheckoutPage extends StatelessWidget {
  final String checkoutId;
  final Function(bool) onComplete;
  final Function onCanceled;

  const WebCheckoutPage({
    required this.checkoutId,
    required this.onComplete,
    required this.onCanceled,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          onPressed: () {
            onCanceled();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          // Debug complete order
          Visibility(
            visible: !kReleaseMode,
            child: IconButton(
              onPressed: () {
                onComplete(true);
              },
              icon: const Icon(Icons.check),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: CheckoutSheetWeb(
              checkoutId: checkoutId,
              onComplete: onComplete,
            ),
          ),
        ],
      ),
    );
  }
}
