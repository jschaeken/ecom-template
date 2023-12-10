import 'dart:async';

import 'package:ecom_template/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:ecom_template/features/checkout/presentation/widgets/checkout_dialogues.dart';
import 'package:flutter/material.dart';

StreamSubscription<CheckoutState>? setCheckoutListerOrderCompletePopUp({
  required Stream<CheckoutState> stream,
  required BuildContext context,
}) {
  return stream.listen((event) {
    if (event is CheckoutCompleted) {
      showOrderCompletedConfirmationPopUp(context, event.orderId);
    } else if (event is CheckoutError) {
      showOrderErrorDialog(context);
    }
  });
}
