import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/exceptions.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/network/network_info.dart';
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
        final response = await customerAuthDatasource
            .signInWithEmailAndPassword(email: email, password: password);
        return Right(response);
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
