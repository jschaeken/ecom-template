import 'package:ecom_template/features/checkout/presentation/pages/checkout_page.dart';
import 'package:flutter/material.dart';

class IncompleteCheckoutModal extends StatefulWidget {
  final Function onClosed;
  final Function(String orderId) onCompleted;

  const IncompleteCheckoutModal(
      {required this.onClosed, required this.onCompleted, Key? key})
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
      final result = await _showCheckoutModal(context);
      if (!result) {
        widget.onClosed();
      } else {
        widget.onCompleted('demo_order_id');
        if (mounted) {
          Navigator.of(context).pop();
        }
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

Future<bool> _showCheckoutModal(BuildContext context) async {
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
  return false;
}
