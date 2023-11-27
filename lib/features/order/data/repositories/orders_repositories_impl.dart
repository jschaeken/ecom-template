import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/exceptions.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/network/network_info.dart';
import 'package:ecom_template/features/customer/data/datasources/customer_info_datasource.dart';
import 'package:ecom_template/features/order/data/datasources/orders_remote_datasource.dart';
import 'package:ecom_template/features/order/domain/entities/order.dart';
import 'package:ecom_template/features/order/domain/repositories/orders_repository.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final CustomerInfoDataSource customerInfoDataSource;

  OrdersRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.customerInfoDataSource,
  });

  @override
  Future<Either<Failure, List<ShopOrder>>> getAllOrders() async {
    try {
      // Get customer access token from customer info data source

      // Check if network is connected and call the remote data source
      if (await networkInfo.isConnected) {
        String? customerAccessToken;
        try {
          customerAccessToken =
              await customerInfoDataSource.getCustomerAccessToken();
        } catch (e) {
          throw CacheException();
        }
        if (customerAccessToken == null) {
          throw const AuthException(message: 'customerAccessToken is null');
        }

        final orderModels =
            await remoteDataSource.getAllOrders(customerAccessToken);

        final List<ShopOrder> orders = orderModels;
        return Right(orders);
      } else {
        return Left(InternetConnectionFailure());
      }
    } on ServerException {
      return Left(ServerFailure());
    } on AuthException {
      return const Left(AuthFailure());
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
