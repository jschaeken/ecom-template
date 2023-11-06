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
    String uniqueKey = params.bagItem.parentProductId + params.bagItem.id;
    for (int i = 0; i < (params.bagItem.selectedOptions?.length ?? 0); i++) {
      uniqueKey += params.bagItem.selectedOptions![i].value;
    }
    final updatedWithKey = params.bagItem.copyWith(uniqueKey: uniqueKey);
    return await repository.addBagItem(updatedWithKey);
  }
}

class BagItemParams extends Equatable {
  final BagItem bagItem;
  final int quantity;

  const BagItemParams({required this.bagItem, this.quantity = 1});

  @override
  List<Object?> get props => [bagItem, quantity];
}
