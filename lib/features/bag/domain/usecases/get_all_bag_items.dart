import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/bag/domain/repositories/bag_repository.dart';

class GetAllBagItems extends UseCase<List<BagItem>, NoParams> {
  final BagRepository repository;

  GetAllBagItems({required this.repository});

  @override
  Future<Either<Failure, List<BagItem>>> call(NoParams params) async {
    return await repository.getBagItems();
  }
}
