part of 'checkout_bloc.dart';

sealed class CheckoutEvent extends Equatable {
  final List<BagItem> bagItems;

  const CheckoutEvent({
    required this.bagItems,
  });

  @override
  List<Object> get props => [bagItems];
}

class AddToCheckoutEvent extends CheckoutEvent {
  final String email;
  final ShopShippingAddress shippingAddress;

  const AddToCheckoutEvent({
    required List<BagItem> bagItems,
    required this.email,
    required this.shippingAddress,
  }) : super(bagItems: bagItems);

  @override
  List<Object> get props => [bagItems];
}

class CheckoutClosedEvent extends CheckoutEvent {
  const CheckoutClosedEvent() : super(bagItems: const []);

  @override
  List<Object> get props => [];
}

class CheckoutCompletedEvent extends CheckoutEvent {
  final String checkoutId;

  const CheckoutCompletedEvent({
    required this.checkoutId,
  }) : super(bagItems: const []);

  @override
  List<Object> get props => [checkoutId];
}

class GetCheckoutInfoEvent extends CheckoutEvent {
  final String checkoutId;

  const GetCheckoutInfoEvent({
    required this.checkoutId,
  }) : super(bagItems: const []);

  @override
  List<Object> get props => [checkoutId];
}

class AddDiscountCodeEvent extends CheckoutEvent {
  final ShopCheckout checkout;
  final String discountCode;

  const AddDiscountCodeEvent({
    required this.checkout,
    required this.discountCode,
  }) : super(bagItems: const []);

  @override
  List<Object> get props => [checkout, discountCode];
}

class RemoveDiscountCodeEvent extends CheckoutEvent {
  final ShopCheckout checkout;
  final String discountCode;

  const RemoveDiscountCodeEvent({
    required this.checkout,
    required this.discountCode,
  }) : super(bagItems: const []);

  @override
  List<Object> get props => [checkout, discountCode];
}
