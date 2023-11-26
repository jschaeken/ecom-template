import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:ecom_template/features/shop/domain/repositories/product_repository.dart';
import 'package:equatable/equatable.dart';

class GetProductsByListIds implements UseCase<List<ShopProduct>, ListIdParams> {
  final ProductRepository repository;

  GetProductsByListIds({required this.repository});

  @override
  Future<Either<Failure, List<ShopProduct>>> call(ListIdParams params) {
    return repository.getProductsByListIds(
      params.ids,
    );
  }
}

class ListIdParams extends Equatable {
  final List<String> ids;

  const ListIdParams({required this.ids});

  @override
  List<Object?> get props => [ids];
}
