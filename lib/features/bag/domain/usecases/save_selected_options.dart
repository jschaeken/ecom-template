import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/bag/domain/entities/options_selection.dart';
import 'package:ecom_template/features/bag/domain/repositories/bag_repository.dart';
import 'package:equatable/equatable.dart';

class SaveSelectedOptions extends UseCase<void, SelectedOptionsParams> {
  final BagRepository repository;

  SaveSelectedOptions({required this.repository});

  @override
  Future<Either<Failure, void>> call(SelectedOptionsParams params) async {
    return await repository.saveSelectedOptions(
        params.productId, params.optionsSelection);
  }
}

class SelectedOptionsParams extends Equatable {
  final String productId;
  final OptionsSelections optionsSelection;

  const SelectedOptionsParams(
      {required this.productId, required this.optionsSelection});

  @override
  List<Object?> get props => [productId, optionsSelection];
}
