import 'package:ecom_template/features/checkout/presentation/pages/checkout_page.dart';
import 'package:flutter/material.dart';

class CheckoutModal extends StatefulWidget {
  final Function onClosed;

  const CheckoutModal({required this.onClosed, super.key});

  @override
  State<CheckoutModal> createState() => _CheckoutModalState();
}

class _CheckoutModalState extends State<CheckoutModal> {
  @override
  void initState() {
    super.initState();
    // postframe callback
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _showCheckoutModal(context);
      widget.onClosed();
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

Future<void> _showCheckoutModal(BuildContext context) async {
  await showModalBottomSheet(
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
        return const SizedBox(height: 600, child: CheckoutPage());
      });
}
