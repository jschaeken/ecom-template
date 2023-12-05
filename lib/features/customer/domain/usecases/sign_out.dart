import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/customer/domain/repositories/customer_auth_repository.dart';

class SignOut extends UseCase<WriteSuccess, NoParams> {
  final CustomerAuthRepository repository;

  SignOut({required this.repository});

  @override
  Future<Either<Failure, WriteSuccess>> call(NoParams params) async {
    return await repository.signOut();
  }
}
