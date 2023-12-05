import 'package:bloc/bloc.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/order/domain/entities/order.dart';
import 'package:ecom_template/features/order/domain/usecases/get_all_orders.dart';
import 'package:equatable/equatable.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final GetAllOrders getAllOrders;

  OrdersBloc({
    required this.getAllOrders,
  }) : super(OrdersInitial()) {
    on<OrdersEvent>((event, emit) async {
      switch (event.runtimeType) {
        case GetAllOrdersEvent:
          await _handleGetAllOrders(emit);
          break;
        default:
          break;
      }
    });
  }

  Future<void> _handleGetAllOrders(Emitter<OrdersState> emit) async {
    emit(OrdersLoading());
    final failureOrOrders = await getAllOrders(NoParams());
    failureOrOrders.fold((failure) => emit(OrdersError(failure: failure)),
        (orders) {
      if (orders.isEmpty) {
        emit(OrdersEmpty());
        return;
      }
      emit(OrdersLoaded(orders: orders));
    });
    return;
  }
}
