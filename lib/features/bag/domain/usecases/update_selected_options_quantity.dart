import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/bag/domain/repositories/bag_repository.dart';
import 'package:ecom_template/features/bag/domain/usecases/save_selected_options.dart';

class UpdateSelectedOptionsQuantity
    implements UseCase<void, SelectedOptionsParams> {
  final BagRepository repository;

  UpdateSelectedOptionsQuantity({required this.repository});

  @override
  Future<Either<Failure, void>> call(SelectedOptionsParams params) async {
    return await repository.updateSelectedOptionsQuantity(
        params.productId, params.optionsSelection);
  }
}
