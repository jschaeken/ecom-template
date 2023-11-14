import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/features/bag/data/datasources/bag_items_local_datasource.dart';
import 'package:ecom_template/features/bag/data/datasources/options_selection_local_datasource.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item_data.dart';
import 'package:ecom_template/features/bag/domain/entities/options_selection.dart';
import 'package:ecom_template/features/bag/domain/repositories/bag_repository.dart';
import 'package:ecom_template/features/shop/data/datasources/product_remote_datasource.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:flutter/foundation.dart';

class BagRepositoryImpl implements BagRepository {
  final BagItemsLocalDataSource bagItemsDataSource;
  final OptionsSelectionDataSource optionsSelectionDataSource;
  final ProductRemoteDataSource productRemoteDataSource;

  BagRepositoryImpl(
      {required this.bagItemsDataSource,
      required this.optionsSelectionDataSource,
      required this.productRemoteDataSource});

  @override
  Future<Either<Failure, List<BagItem>>> getBagItems() async {
    try {
      // Get all bag items from local cache
      List<BagItemData> cacheResponse =
          await bagItemsDataSource.getAllLocalBagItemData();
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
              parentProductTitle: product.title,
              productVariant: selectedVariant,
              quantity: bagItemData.quantity,
              parentProductId: bagItemData.parentProductId,
            ),
          );
        } catch (e) {
          debugPrint(e.toString());
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
      final response = await bagItemsDataSource.addBagItemData(bagItemData);
      return Right(response);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, WriteSuccess>> removeBagItem(
      BagItemData bagItemData) async {
    try {
      final response = await bagItemsDataSource
          .removeBagItemData(bagItemData.productVariantId);
      return Right(response);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, WriteSuccess>> updateBagItem(
      BagItemData bagItemData) async {
    try {
      final response = await bagItemsDataSource.setBagItemDataQuantity(
          bagItemData.productVariantId, bagItemData.quantity);
      return Right(response);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, OptionsSelections>> getSavedSelectedOptions(
      String productId) async {
    try {
      OptionsSelections? response =
          await optionsSelectionDataSource.getSavedSelectedOptions(productId);
      if (response == null) {
        return Left(CacheFailure());
      } else {
        return Right(response);
      }
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, WriteSuccess>> saveSelectedOptions(
      String productId, OptionsSelections optionsSelections) async {
    try {
      await optionsSelectionDataSource.saveSelectedOptions(
        productId,
        optionsSelections,
      );
      return const Right(WriteSuccess());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, WriteSuccess>> updateSelectedOptions(
      String productId, OptionsSelections newOptionSelection) async {
    try {
      final currentOptionsSelections =
          await optionsSelectionDataSource.getSavedSelectedOptions(productId);
      if (currentOptionsSelections == null) {
        await optionsSelectionDataSource.saveSelectedOptions(
            productId, newOptionSelection);
        return const Right(WriteSuccess());
      } else {
        Map<String, int> newMap = {};
        currentOptionsSelections.selectedOptions.forEach((key, value) {
          newMap[key] = value;
        });
        newMap.addAll(newOptionSelection.selectedOptions);
        await optionsSelectionDataSource.saveSelectedOptions(
            productId, OptionsSelections(selectedOptions: newMap));
        return const Right(WriteSuccess());
      }
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
