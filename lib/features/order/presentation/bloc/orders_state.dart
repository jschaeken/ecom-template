part of 'orders_bloc.dart';

sealed class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object> get props => [];
}

final class OrdersInitial extends OrdersState {}

final class OrdersLoading extends OrdersState {}

final class OrdersEmpty extends OrdersState {}

final class OrdersLoaded extends OrdersState {
  final List<ShopOrder> orders;

  const OrdersLoaded({
    required this.orders,
  });

  @override
  List<Object> get props => [orders];
}

final class OrdersError extends OrdersState {
  final Failure failure;

  const OrdersError({
    required this.failure,
  });

  @override
  List<Object> get props => [failure];
}
