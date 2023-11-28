import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'customer_auth_event.dart';
part 'customer_auth_state.dart';

class CustomerAuthBloc extends Bloc<CustomerAuthEvent, CustomerAuthState> {
  CustomerAuthBloc() : super(CustomerAuthInitial()) {
    on<CustomerAuthEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
