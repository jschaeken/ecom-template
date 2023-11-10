import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item_data.dart';

abstract class BagItemsRepository {
  Future<Either<Failure, List<BagItem>>> getBagItems();

  Future<Either<Failure, WriteSuccess>> addBagItem(BagItemData bagItemData);

  Future<Either<Failure, WriteSuccess>> removeBagItem(BagItemData id);

  Future<Either<Failure, WriteSuccess>> updateBagItem(BagItemData bagItemData);
}
