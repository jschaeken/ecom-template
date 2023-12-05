part of 'customer_auth_bloc.dart';

sealed class CustomerAuthState extends Equatable {
  const CustomerAuthState();

  @override
  List<Object> get props => [];
}

final class CustomerAuthInitial extends CustomerAuthState {}

final class CustomerAuthLoading extends CustomerAuthState {}

final class CustomerAuthenticated extends CustomerAuthState {
  final ShopShopifyUser user;

  const CustomerAuthenticated({
    required this.user,
  });

  @override
  List<Object> get props => [user];
}

final class CustomerUnauthenticatedLogin extends CustomerAuthState {
  final List<String> errors;

  const CustomerUnauthenticatedLogin({
    this.errors = const [],
  });

  @override
  List<Object> get props => [
        errors,
      ];
}

final class CustomerUnauthenticatedCreateAccount extends CustomerAuthState {
  final List<String> errors;

  const CustomerUnauthenticatedCreateAccount({
    this.errors = const [],
  });

  @override
  List<Object> get props => [
        errors,
      ];
}

final class CustomerAuthError extends CustomerAuthState {
  final Failure failure;

  const CustomerAuthError({
    required this.failure,
  });

  @override
  List<Object> get props => [failure];
}
