import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/features/bag/data/datasources/bag_items_local_datasource.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/bag/domain/repositories/bag_items_repository.dart';

class BagItemsRepositoryImpl implements BagItemsRepository {
  final BagItemsLocalDataSource dataSource;

  BagItemsRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<BagItem>>> getBagItems() async {
    try {
      final response = await dataSource.getAllBagItems();
      return Right(response);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, WriteSuccess>> addBagItem(BagItem bagItem) async {
    try {
      final response = await dataSource.addBagItem(bagItem);
      return Right(response);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, WriteSuccess>> removeBagItem(String id) async {
    try {
      final response = await dataSource.removeBagItem(id);
      return Right(response);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Stream<List<BagItem>>>> watchBagItems() async {
    try {
      final reponse = await dataSource.watchBagItems();
      return Right(reponse);
    } catch (e) {
      throw CacheFailure();
    }
  }
}
