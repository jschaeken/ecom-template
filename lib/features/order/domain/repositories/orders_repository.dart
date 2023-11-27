import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/features/order/domain/entities/order.dart';

abstract class OrdersRepository {
  Future<Either<Failure, List<ShopOrder>>> getAllOrders();
}
