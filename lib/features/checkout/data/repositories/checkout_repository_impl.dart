import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/network/network_info.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/features/checkout/data/datasources/checkout_remote_datasource.dart';
import 'package:ecom_template/features/checkout/data/models/checkout_model.dart';
import 'package:ecom_template/features/checkout/domain/entities/checkout.dart';
import 'package:ecom_template/features/checkout/domain/entities/checkout_user_error.dart';
import 'package:ecom_template/features/checkout/domain/entities/line_item.dart';
import 'package:ecom_template/features/checkout/domain/entities/shipping_address.dart';
import 'package:ecom_template/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:shopify_flutter/mixins/src/shopfiy_error.dart';
import 'package:shopify_flutter/models/src/checkout/line_item/line_item.dart';

import '../../../../core/error/failures.dart';

const DISCOUNT_CODE_FAILURE_MESSAGE = 'Discount code is not valid';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutRemoteDataSource dataSource;
  final NetworkInfo networkInfo;

  CheckoutRepositoryImpl({required this.dataSource, required this.networkInfo});

  @override
  Future<Either<Failure, ShopCheckout>> createCheckout({
    List<ShopLineItem>? lineItems,
    ShopShippingAddress? shippingAddress,
    String? email,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.createCheckout(
            lineItems:
                lineItems?.map((e) => e.toLineItem()).toList() ?? <LineItem>[],
            shippingAddress: ShopShippingAddress.toAddress(shippingAddress),
            email: email);
        return Right(response);
      } catch (e) {
        debugPrint(e.toString());
        return Left(ServerFailure());
      }
    } else {
      return const Left(InternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, ShopCheckout>> getCheckoutById(
      {required String checkoutId}) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await dataSource.getCheckoutInfo(checkoutId: checkoutId);
        return Right(response);
      } on ShopifyException catch (e, stackTrace) {
        log('e.runtimeType ${e.runtimeType.toString()}');
        log('e.toString() ${e.toString()}');
        log('e.errors ${e.errors}');
        return Left(ServerFailure());
      } catch (e, stackTrace) {
        log('e.runtimeType ${e.runtimeType.toString()}');
        log('getCheckoutById error: ${e.toString()}');
        log('getCheckoutById stackTrace: ${stackTrace.toString()}');
        return Left(ServerFailure());
      }
    } else {
      return const Left(InternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, ShopCheckout>> addDiscountCode(
      {required String checkoutId, required String discountCode}) async {
    if (await networkInfo.isConnected) {
      try {
        ShopCheckoutModel response = await dataSource.addDiscountCode(
            checkoutId: checkoutId, discountCode: discountCode);
        ShopCheckout checkout = response.copyWith(
          discountCodesApplied: [discountCode],
        );
        return Right(checkout);
      } on ShopifyException catch (e) {
        debugPrint(e.runtimeType.toString());
        debugPrint(e.toString());
        List<CheckoutUserError> userErrors = [];
        if (e.errors != null) {
          for (var error in e.errors!) {
            debugPrint(error.toString());
            debugPrint(error?.runtimeType.toString() ?? 'Unknown runtimetype');
            userErrors.add(
              CheckoutUserError(
                code: '1',
                fields: const [],
                message: error ?? 'Unknown error',
              ),
            );
          }
        }
        return Left(CheckoutUserFailure(userErrors: userErrors));
      } catch (e) {
        debugPrint(e.runtimeType.toString());
        debugPrint(e.toString());
        return Left(ServerFailure());
      }
    } else {
      return const Left(InternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, WriteSuccess>> removeDiscountCode(
      {required String checkoutId, required String discountCode}) async {
    if (await networkInfo.isConnected) {
      try {
        await dataSource.removeDiscountCode(
            checkoutId: checkoutId, discountCode: discountCode);
        return const Right(WriteSuccess());
      } catch (e) {
        debugPrint(e.toString());
        return Left(ServerFailure());
      }
    } else {
      return const Left(InternetConnectionFailure());
    }
  }
}
