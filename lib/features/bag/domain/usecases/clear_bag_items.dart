import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/bag/domain/repositories/bag_repository.dart';

class ClearBagItems extends UseCase<void, NoParams> {
  final BagRepository repository;

  ClearBagItems({required this.repository});

  @override
  Future<Either<Failure, WriteSuccess>> call(NoParams params) async {
    return await repository.clearBagItems();
  }
}
