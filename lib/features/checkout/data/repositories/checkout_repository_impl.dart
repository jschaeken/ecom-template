import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/network/network_info.dart';
import 'package:ecom_template/features/checkout/data/datasources/checkout_remote_datasource.dart';
import 'package:ecom_template/features/checkout/domain/entities/checkout.dart';
import 'package:ecom_template/features/checkout/domain/entities/line_item.dart';
import 'package:ecom_template/features/checkout/domain/entities/shipping_address.dart';
import 'package:ecom_template/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:shopify_flutter/models/src/checkout/line_item/line_item.dart';

import '../../../../core/error/failures.dart';

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
      return Left(InternetConnectionFailure());
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
      } catch (e) {
        debugPrint(e.toString());
        return Left(ServerFailure());
      }
    } else {
      return Left(InternetConnectionFailure());
    }
  }
}
