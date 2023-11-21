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
  final String orderId;

  const CheckoutCompletedEvent({
    required this.orderId,
  }) : super(bagItems: const []);

  @override
  List<Object> get props => [orderId];
}

class GetCheckoutInfoEvent extends CheckoutEvent {
  final String id;

  const GetCheckoutInfoEvent({
    required this.id,
  }) : super(bagItems: const []);

  @override
  List<Object> get props => [id];
}
