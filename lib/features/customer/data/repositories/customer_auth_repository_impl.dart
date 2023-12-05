import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/exceptions.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/network/network_info.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/features/customer/data/datasources/customer_auth_datasource.dart';
import 'package:ecom_template/features/customer/data/datasources/customer_info_datasource.dart';
import 'package:ecom_template/features/customer/domain/entities/shopify_user.dart';
import 'package:ecom_template/features/customer/domain/repositories/customer_auth_repository.dart';

class CustomerAuthRepositoryImpl implements CustomerAuthRepository {
  final CustomerAuthDatasource customerAuthDatasource;
  final NetworkInfo networkInfo;

  CustomerAuthRepositoryImpl({
    required this.customerAuthDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ShopShopifyUser>> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await customerAuthDatasource.signInWithEmailAndPassword(
            email: email, password: password);
        return Right(user);
      } on AuthException catch (e) {
        return Left(AuthFailure(message: e.message, errors: [e.message]));
      }
    } else {
      return const Left(
        InternetConnectionFailure(message: INTERNET_CONNECTION_FAILURE_MESSAGE),
      );
    }
  }

  @override
  Future<Either<Failure, ShopShopifyUser>> createAccount({
    required String email,
    required String password,
    required String confirmPassword,
    String? firstName,
    String? lastName,
    String? phone,
    bool? acceptsMarketing,
  }) async {
    List<String> errors = [];
    // Test locally for textfield validation
    if (email.isEmpty) {
      errors.add('Email cannot be empty');
    }
    if (password.isEmpty) {
      errors.add('Password cannot be empty');
    }
    if (confirmPassword.isEmpty) {
      errors.add('Confirm Password cannot be empty');
    }
    if (password != confirmPassword) {
      errors.add('Passwords do not match');
    }
    if (errors.isNotEmpty) {
      return Left(AuthFailure(message: 'Validation Error', errors: errors));
    }
    if (await networkInfo.isConnected) {
      try {
        final user = await customerAuthDatasource.createAccount(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          acceptsMarketing: acceptsMarketing,
        );
        return Right(user);
      } on AuthException catch (e) {
        return Left(AuthFailure(message: e.message, errors: [e.message]));
      }
    } else {
      return const Left(
        InternetConnectionFailure(message: INTERNET_CONNECTION_FAILURE_MESSAGE),
      );
    }
  }

  @override
  Future<Either<Failure, ShopShopifyUser?>> getCurrentUser() async {
    if (await networkInfo.isConnected) {
      try {
        final user = await customerAuthDatasource.getCurrentUser();
        return Right(user);
      } on AuthException catch (e) {
        return Left(AuthFailure(message: e.message));
      }
    } else {
      return Future.value(
        const Left(
          InternetConnectionFailure(
              message: INTERNET_CONNECTION_FAILURE_MESSAGE),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, WriteSuccess>> signOut() async {
    if (await networkInfo.isConnected) {
      try {
        await customerAuthDatasource.signOut();
        return const Right(WriteSuccess());
      } on AuthException catch (e) {
        return Left(AuthFailure(message: e.message));
      }
    } else {
      return const Left(
        InternetConnectionFailure(message: INTERNET_CONNECTION_FAILURE_MESSAGE),
      );
    }
  }
}
