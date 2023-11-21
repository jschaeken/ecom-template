part of 'checkout_bloc.dart';

sealed class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object> get props => [];
}

final class CheckoutInitial extends CheckoutState {}

final class CheckoutLoading extends CheckoutState {}

final class CheckoutLoaded extends CheckoutState {
  final ShopCheckout checkout;

  const CheckoutLoaded({required this.checkout});

  @override
  List<Object> get props => [checkout];
}

final class CheckoutCompleted extends CheckoutState {
  final String orderId;

  const CheckoutCompleted({required this.orderId});

  @override
  List<Object> get props => [orderId];
}

final class CheckoutError extends CheckoutState {
  final Failure failure;
  final String? checkoutId;

  const CheckoutError({required this.failure, this.checkoutId});

  @override
  List<Object> get props => [failure];
}
