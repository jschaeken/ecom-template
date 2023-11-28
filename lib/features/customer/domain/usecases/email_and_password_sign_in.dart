import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/customer/domain/entities/shopify_user.dart';
import 'package:ecom_template/features/customer/domain/repositories/customer_auth_repository.dart';
import 'package:equatable/equatable.dart';

class EmailAndPasswordSignIn
    extends UseCase<AuthFailure, EmailAndPasswordSignInParams> {
  final CustomerAuthRepository repository;

  EmailAndPasswordSignIn({required this.repository});

  @override
  Future<Either<Failure, ShopShopifyUser>> call(
      EmailAndPasswordSignInParams params) async {
    return await repository.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class EmailAndPasswordSignInParams extends Equatable {
  final String email;
  final String password;

  const EmailAndPasswordSignInParams(
      {required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
