import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/bag/domain/repositories/bag_repository.dart';

import '../entities/bag_item_data.dart';

class AddBagItem extends UseCase<BagItem, BagItemData> {
  final BagRepository repository;

  AddBagItem({required this.repository});

  @override
  Future<Either<Failure, WriteSuccess>> call(BagItemData params) async {
    return await repository.addBagItem(params);
  }
}
