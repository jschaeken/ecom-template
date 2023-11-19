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

final class CheckoutError extends CheckoutState {
  final Failure failure;

  const CheckoutError({required this.failure});

  @override
  List<Object> get props => [failure];
}
