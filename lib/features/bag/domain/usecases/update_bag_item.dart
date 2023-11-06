import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/bag/domain/repositories/bag_items_repository.dart';
import 'package:ecom_template/features/bag/domain/usecases/add_bag_item.dart';

import '../../../../core/error/failures.dart';

class UpdateBagItem extends UseCase<BagItem, BagItemParams> {
  final BagItemsRepository repository;

  UpdateBagItem({required this.repository});

  @override
  Future<Either<Failure, WriteSuccess>> call(BagItemParams params) async {
    return await repository.updateBagItem(params.quantity, params.bagItem);
  }
}
