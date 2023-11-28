part of 'customer_auth_bloc.dart';

sealed class CustomerAuthState extends Equatable {
  const CustomerAuthState();
  
  @override
  List<Object> get props => [];
}

final class CustomerAuthInitial extends CustomerAuthState {}
