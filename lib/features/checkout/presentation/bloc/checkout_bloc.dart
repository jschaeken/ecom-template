import 'package:bloc/bloc.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/checkout/domain/entities/checkout.dart';
import 'package:ecom_template/features/checkout/domain/entities/shipping_address.dart';
import 'package:ecom_template/features/checkout/domain/usecases/bag_items_to_line_items.dart';
import 'package:ecom_template/features/checkout/domain/usecases/create_checkout.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CreateCheckout createCheckout;
  final BagItemsToLineItems bagItemsToLineItems;
  bool hasCheckout = false;

  CheckoutBloc({
    required this.createCheckout,
    required this.bagItemsToLineItems,
  }) : super(CheckoutInitial()) {
    on<CheckoutEvent>((event, emit) async {
      switch (event.runtimeType) {
        case AddToCheckoutEvent:
          event as AddToCheckoutEvent;
          emit(CheckoutLoading());
          final lineItems = await bagItemsToLineItems(bagItems: event.bagItems);
          debugPrint(lineItems.length.toString());
          final checkout = await createCheckout(ShopCheckoutParams(
            lineItems: lineItems,
            email: event.email,
            shippingAddress: event.shippingAddress,
          ));
          checkout.fold((failure) {
            emit(CheckoutError(failure: failure));
          }, (shopCheckout) {
            for (var element in shopCheckout.lineItems) {
              debugPrint(element.variantId.toString());
            }
            emit(CheckoutLoaded(checkout: shopCheckout));
          });
          break;
        case CheckoutCompletedEvent:
          event as CheckoutCompletedEvent;
          emit(CheckoutCompleted(orderId: event.orderId));
          break;

        case CheckoutClosedEvent:
          emit(CheckoutInitial());
      }
    });
  }
}

/*

switch (checkoutState.runtimeType) {
  case CheckoutInitial:
    return const TextBody(text: 'Initial');
  case CheckoutLoading:
    return const TextBody(text: 'Loading');
  case CheckoutLoaded:
    return const TextBody(text: 'Loaded');
  case CheckoutError:
    return const TextBody(text: 'Error');
  default:
    return const TextBody(text: 'Default');
}

*/
