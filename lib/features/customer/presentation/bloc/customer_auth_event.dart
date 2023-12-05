part of 'customer_auth_bloc.dart';

sealed class CustomerAuthEvent extends Equatable {
  const CustomerAuthEvent();

  @override
  List<Object> get props => [];
}

class CustomerAuthEmailAndPasswordSignInEvent extends CustomerAuthEvent {
  final String email;
  final String password;

  const CustomerAuthEmailAndPasswordSignInEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class GetAuthStateEvent extends CustomerAuthEvent {}

class SignOutEvent extends CustomerAuthEvent {}

class PushCreateAccountStateEvent extends CustomerAuthEvent {}

class PushLoginStateEvent extends CustomerAuthEvent {}

class CreateAccountEvent extends CustomerAuthEvent {
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String password;
  final String confirmPassword;
  final bool acceptsMarketing;

  const CreateAccountEvent({
    required this.email,
    this.firstName,
    this.lastName,
    this.phone,
    required this.password,
    required this.confirmPassword,
    this.acceptsMarketing = false,
  });

  @override
  List<Object> get props => [
        email,
        firstName ?? '',
        lastName ?? '',
        phone ?? '',
        password,
        confirmPassword,
        acceptsMarketing,
      ];
}
