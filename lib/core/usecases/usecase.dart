import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:equatable/equatable.dart';

abstract class UseCase<T, Params> {
  Future<Either<Failure, dynamic>> call(Params params);
}

class Params extends Equatable {
  final String id;

  const Params({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
