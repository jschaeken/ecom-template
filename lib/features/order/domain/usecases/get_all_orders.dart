import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/order/domain/entities/order.dart';
import 'package:ecom_template/features/order/domain/repositories/orders_repository.dart';

class GetAllOrders extends UseCase<List<ShopOrder>, NoParams> {
  GetAllOrders({required this.repository});

  final OrdersRepository repository;

  @override
  Future<Either<Failure, List<ShopOrder>>> call(NoParams params) async {
    return await repository.getAllOrders();
  }
}
