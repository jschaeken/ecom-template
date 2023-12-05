import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/customer/domain/entities/shopify_user.dart';
import 'package:ecom_template/features/customer/domain/repositories/customer_auth_repository.dart';
import 'package:equatable/equatable.dart';

class CreateAccount extends UseCase<AuthFailure, CreateAccountParams> {
  final CustomerAuthRepository repository;

  CreateAccount({required this.repository});

  @override
  Future<Either<Failure, ShopShopifyUser>> call(
      CreateAccountParams params) async {
    return await repository.createAccount(
      email: params.email,
      password: params.password,
      confirmPassword: params.confirmPassword,
      firstName: params.firstName,
      lastName: params.lastName,
      phone: params.phone,
      acceptsMarketing: params.acceptsMarketing,
    );
  }
}

class CreateAccountParams extends Equatable {
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String password;
  final String confirmPassword;
  final bool acceptsMarketing;

  const CreateAccountParams({
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
