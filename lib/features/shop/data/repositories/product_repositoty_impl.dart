import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/exceptions.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/network/network_info.dart';
import 'package:ecom_template/features/shop/data/datasources/product_remote_datasource.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_collection.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:ecom_template/features/shop/domain/repositories/product_repository.dart';

class ProductRepositoryImplementation implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImplementation({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ShopProduct>>> getFullProducts() async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDataSource.getAllProducts());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(InternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, ShopProduct>> getProductById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDataSource.getProductById(id));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(InternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<ShopProduct>>> getAllProductsByCollectionId(
      String id) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDataSource.getAllProductsByCollectionId(id));
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(InternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<ShopCollection>>> getAllCollections() async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDataSource.getAllCollections());
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(InternetConnectionFailure());
    }
  }
}
