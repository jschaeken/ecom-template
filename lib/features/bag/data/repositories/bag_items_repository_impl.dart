import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/features/bag/data/datasources/bag_items_local_datasource.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item_data.dart';
import 'package:ecom_template/features/bag/domain/repositories/bag_items_repository.dart';
import 'package:ecom_template/features/shop/data/datasources/product_remote_datasource.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';

class BagItemsRepositoryImpl implements BagItemsRepository {
  final BagItemsLocalDataSource dataSource;
  final ProductRemoteDataSource productRemoteDataSource;

  BagItemsRepositoryImpl(
      {required this.dataSource, required this.productRemoteDataSource});

  @override
  Future<Either<Failure, List<BagItem>>> getBagItems() async {
    try {
      // Get all bag items from local cache
      List<BagItemData> cacheResponse =
          await dataSource.getAllLocalBagItemData();
      List<BagItem> bagItems = [];
      for (BagItemData bagItemData in cacheResponse) {
        // Get product from remote
        final product = await productRemoteDataSource
            .getProductById(bagItemData.parentProductId);
        // Get the saved product variant from the ShopProduct
        try {
          ShopProductProductVariant selectedVariant = product.productVariants
              .firstWhere(
                  (element) => element.id == bagItemData.productVariantId);
          bagItems.add(
            BagItem.fromShopProductVariant(
              product: selectedVariant,
              quantity: bagItemData.quantity,
              parentProductId: bagItemData.parentProductId,
            ),
          );
        } catch (e) {
          print(e.toString());
          continue;
        }
      }
      return Right(bagItems);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  /// Unique key for each bag item is the productVariantId
  @override
  Future<Either<Failure, WriteSuccess>> addBagItem(
      BagItemData bagItemData) async {
    try {
      final response = await dataSource.addBagItemData(bagItemData);
      return Right(response);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, WriteSuccess>> removeBagItem(
      BagItemData bagItemData) async {
    try {
      final response =
          await dataSource.removeBagItemData(bagItemData.productVariantId);
      return Right(response);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, WriteSuccess>> updateBagItem(
      BagItemData bagItemData) async {
    try {
      final response = await dataSource.setBagItemDataQuantity(
          bagItemData.productVariantId, bagItemData.quantity);
      return Right(response);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
