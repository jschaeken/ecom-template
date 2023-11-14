import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/bag/domain/entities/options_selection.dart';
import 'package:ecom_template/features/bag/domain/repositories/bag_repository.dart';

class GetSavedSelectedOptions extends UseCase<List<OptionsSelections>, Params> {
  final BagRepository repository;

  GetSavedSelectedOptions({required this.repository});

  @override
  Future<Either<Failure, OptionsSelections>> call(Params params) async {
    return await repository.getSavedSelectedOptions(params.id);
  }
}
