import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/bag/domain/repositories/bag_items_repository.dart';
import 'package:equatable/equatable.dart';

class AddBagItem extends UseCase<BagItem, BagItemParams> {
  final BagItemsRepository repository;

  AddBagItem({required this.repository});

  @override
  Future<Either<Failure, WriteSuccess>> call(BagItemParams params) async {
    return await repository.addBagItem(params.bagItem);
  }
}

class BagItemParams extends Equatable {
  final BagItem bagItem;

  const BagItemParams({required this.bagItem});

  @override
  List<Object?> get props => [bagItem];
}
