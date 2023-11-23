import 'package:bloc/bloc.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/checkout/domain/entities/checkout.dart';
import 'package:ecom_template/features/checkout/domain/entities/shipping_address.dart';
import 'package:ecom_template/features/checkout/domain/usecases/add_discount_code.dart';
import 'package:ecom_template/features/checkout/domain/usecases/bag_items_to_line_items.dart';
import 'package:ecom_template/features/checkout/domain/usecases/create_checkout.dart';
import 'package:ecom_template/features/checkout/domain/usecases/get_checkout_info.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CreateCheckout createCheckout;
  final BagItemsToLineItems bagItemsToLineItems;
  final GetCheckoutInfo getCheckoutInfo;
  final AddDiscountCode addDiscountCode;
  bool hasCheckout = false;

  CheckoutBloc({
    required this.createCheckout,
    required this.bagItemsToLineItems,
    required this.getCheckoutInfo,
    required this.addDiscountCode,
  }) : super(CheckoutInitial()) {
    on<CheckoutEvent>((event, emit) async {
      switch (event.runtimeType) {
        case AddToCheckoutEvent:
          event as AddToCheckoutEvent;
          emit(CheckoutLoading());
          final lineItems = await bagItemsToLineItems(bagItems: event.bagItems);
          debugPrint(lineItems.length.toString());
          final checkout = await createCheckout(ShopCreateCheckoutParams(
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
        case GetCheckoutInfoEvent:
          event as GetCheckoutInfoEvent;
          emit(CheckoutLoading());
          final checkout = await getCheckoutInfo(Params(id: event.checkoutId));
          checkout.fold((failure) {
            emit(CheckoutError(failure: failure));
          }, (shopCheckout) {
            if (shopCheckout.order?.id != null) {
              emit(CheckoutCompleted(orderId: shopCheckout.order!.id));
            } else {
              emit(CheckoutLoaded(checkout: shopCheckout));
            }
          });
          break;
        case AddDiscountCodeEvent:
          event as AddDiscountCodeEvent;
          emit(CheckoutLoading());
          final checkout = await addDiscountCode(
            ShopCheckoutActionParams(
              checkoutId: event.checkoutId,
              option: event.discountCode,
            ),
          );
          checkout.fold((failure) {
            emit(
              CheckoutError(failure: failure),
            );
          }, (shopCheckout) {
            emit(
              CheckoutLoaded(checkout: shopCheckout),
            );
          });
          break;
        case CheckoutClosedEvent:
          emit(CheckoutInitial());
      }
    });
  }
}
