import 'package:ecom_template/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:ecom_template/features/checkout/presentation/widgets/checkout_sheet_web.dart';
import 'package:ecom_template/features/order/domain/entities/order_completion.dart';
import 'package:ecom_template/features/shop/presentation/widgets/state_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<OrderCompletion?> showCheckoutModal(BuildContext context) async {
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
      return FractionallySizedBox(
        heightFactor: 0.87,
        child: BlocBuilder<CheckoutBloc, CheckoutState>(
          builder: (context, checkoutState) {
            if (checkoutState is CheckoutLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
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
              return CheckoutSheetWeb(
                checkoutId: checkoutState.checkout.id,
                onComplete: (complete) {
                  // TODO: Implement this feature
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          },
        ),
      );
    },
  );
}
