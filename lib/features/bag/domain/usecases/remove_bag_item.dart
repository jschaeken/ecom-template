import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item_data.dart';
import 'package:ecom_template/features/bag/domain/repositories/bag_repository.dart';

class RemoveBagItem extends UseCase<WriteSuccess, RemBagItemParams> {
  final BagRepository repository;

  RemoveBagItem({required this.repository});

  @override
  Future<Either<Failure, WriteSuccess>> call(RemBagItemParams params) async {
    return await repository.removeBagItem(params.bagItemIndex);
  }
}

class RemBagItemParams {
  final int bagItemIndex;

  RemBagItemParams({required this.bagItemIndex});
}
