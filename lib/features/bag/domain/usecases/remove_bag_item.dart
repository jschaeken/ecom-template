import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/bag/domain/repositories/bag_items_repository.dart';
import 'package:ecom_template/features/bag/domain/usecases/add_bag_item.dart';

class RemoveBagItem extends UseCase<WriteSuccess, BagItemParams> {
  final BagItemsRepository repository;

  RemoveBagItem({required this.repository});

  @override
  Future<Either<Failure, WriteSuccess>> call(BagItemParams params) async {
    return await repository.removeBagItem(params.bagItem.id);
  }
}
