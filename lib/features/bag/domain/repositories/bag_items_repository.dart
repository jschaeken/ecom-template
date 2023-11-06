import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';

abstract class BagItemsRepository {
  Future<Either<Failure, List<BagItem>>> getBagItems();

  Future<Either<Failure, WriteSuccess>> addBagItem(BagItem bagItem);

  Future<Either<Failure, WriteSuccess>> removeBagItem(String id);

  Future<Either<Failure, WriteSuccess>> updateBagItem(
      int quantity, BagItem bagItem);
}
