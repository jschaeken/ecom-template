part of 'orders_bloc.dart';

sealed class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object> get props => [];
}

class GetAllOrdersEvent extends OrdersEvent {
  const GetAllOrdersEvent();
}
