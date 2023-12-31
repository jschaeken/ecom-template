import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item_data.dart';
import 'package:ecom_template/features/bag/domain/repositories/bag_repository.dart';

import '../../../../core/error/failures.dart';

class UpdateBagItem extends UseCase<BagItem, BagItemData> {
  final BagRepository repository;

  UpdateBagItem({required this.repository});

  @override
  Future<Either<Failure, WriteSuccess>> call(BagItemData params) async {
    return await repository.updateBagItem(params);
  }
}
