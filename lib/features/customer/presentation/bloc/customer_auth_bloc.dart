import 'package:bloc/bloc.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/customer/domain/entities/shopify_user.dart';
import 'package:ecom_template/features/customer/domain/usecases/create_account.dart';
import 'package:ecom_template/features/customer/domain/usecases/email_and_password_sign_in.dart';
import 'package:ecom_template/features/customer/domain/usecases/get_auth_state.dart';
import 'package:ecom_template/features/customer/domain/usecases/sign_out.dart';
import 'package:equatable/equatable.dart';

part 'customer_auth_event.dart';
part 'customer_auth_state.dart';

class CustomerAuthBloc extends Bloc<CustomerAuthEvent, CustomerAuthState> {
  final EmailAndPasswordSignIn emailAndPasswordSignIn;
  final GetAuthState getAuthState;
  final SignOut signOut;
  final CreateAccount createAccount;

  CustomerAuthBloc({
    required this.emailAndPasswordSignIn,
    required this.getAuthState,
    required this.signOut,
    required this.createAccount,
  }) : super(CustomerAuthInitial()) {
    on<CustomerAuthEvent>((event, emit) async {
      switch (event.runtimeType) {
        case CustomerAuthEmailAndPasswordSignInEvent:
          event as CustomerAuthEmailAndPasswordSignInEvent;
          emit(CustomerAuthLoading());
          final EmailAndPasswordSignInParams params =
              EmailAndPasswordSignInParams(
            email: event.email,
            password: event.password,
          );
          final failureOrShopifyUser = await emailAndPasswordSignIn(params);
          failureOrShopifyUser.fold(
            (failure) {
              if (failure.runtimeType == AuthFailure) {
                failure as AuthFailure;
                emit(CustomerUnauthenticatedLogin(errors: failure.errors));
              } else {}
            },
            (shopifyUser) => emit(CustomerAuthenticated(user: shopifyUser)),
          );
          break;
        case GetAuthStateEvent:
          emit(CustomerAuthLoading());
          final failureOrShopifyUser = await getAuthState(NoParams());
          failureOrShopifyUser
              .fold((failure) => emit(CustomerAuthError(failure: failure)),
                  (shopifyUser) {
            if (shopifyUser != null) {
              emit(CustomerAuthenticated(user: shopifyUser));
            } else {
              emit(const CustomerUnauthenticatedLogin());
            }
          });
          break;
        case SignOutEvent:
          emit(CustomerAuthLoading());
          final failureOrSuccess = await signOut(NoParams());
          failureOrSuccess.fold(
            (failure) => emit(CustomerAuthError(failure: failure)),
            (success) => emit(const CustomerUnauthenticatedLogin()),
          );
          break;
        case CreateAccountEvent:
          emit(CustomerAuthLoading());
          event as CreateAccountEvent;
          final failureOrShopifyUser = await createAccount(
            CreateAccountParams(
              email: event.email,
              password: event.password,
              confirmPassword: event.confirmPassword,
              firstName: event.firstName,
              lastName: event.lastName,
              phone: event.phone,
              acceptsMarketing: event.acceptsMarketing,
            ),
          );
          failureOrShopifyUser.fold(
            (failure) {
              if (failure.runtimeType == AuthFailure) {
                failure as AuthFailure;
                emit(CustomerUnauthenticatedCreateAccount(
                    errors: failure.errors));
              } else {}
            },
            (shopifyUser) => emit(CustomerAuthenticated(user: shopifyUser)),
          );
          break;
        case PushCreateAccountStateEvent:
          emit(const CustomerUnauthenticatedCreateAccount());
          break;
        case PushLoginStateEvent:
          emit(const CustomerUnauthenticatedLogin());
          break;
      }
    });
  }
}
