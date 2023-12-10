import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/exceptions.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/features/bag/data/datasources/bag_items_local_datasource.dart';
import 'package:ecom_template/features/bag/data/datasources/options_selection_local_datasource.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item_data.dart';
import 'package:ecom_template/features/bag/domain/entities/options_selection.dart';
import 'package:ecom_template/features/bag/domain/repositories/bag_repository.dart';
import 'package:ecom_template/features/bag/domain/usecases/bag_item_data_to_bag_item.dart';
import 'package:ecom_template/features/shop/data/datasources/product_remote_datasource.dart';

class BagRepositoryImpl implements BagRepository {
  final BagItemsLocalDataSource bagItemsDataSource;
  final OptionsSelectionDataSource optionsSelectionDataSource;
  final ProductRemoteDataSource productRemoteDataSource;
  final BagItemDataToBagItem bagItemDataToBagItem;

  BagRepositoryImpl(
      {required this.bagItemsDataSource,
      required this.optionsSelectionDataSource,
      required this.productRemoteDataSource,
      required this.bagItemDataToBagItem});

  @override
  Future<Either<Failure, List<BagItem>>> getBagItems() async {
    try {
      // Get all bag items from local cache
      List<BagItemData> cacheResponse = [];
      try {
        cacheResponse = await bagItemsDataSource.getAllLocalBagItemData();
      } catch (e) {
        throw CacheException();
      }
      List<BagItem> bagItems = [];
      for (BagItemData bagItemData in cacheResponse) {
        final result = await bagItemDataToBagItem(BagItemDataParams(
            bagItemData: bagItemData, id: bagItemData.productVariantId));
        result.fold(
          (l) {},
          (bagItem) => bagItems.add(bagItem),
        );
      }
      return Right(bagItems);
    } on CacheException {
      return Left(CacheFailure());
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  /// Unique key for each bag item is the productVariantId
  @override
  Future<Either<Failure, WriteSuccess>> addBagItem(
      BagItemData bagItemData) async {
    try {
      await bagItemsDataSource.addBagItemData(bagItemData);
      return const Right(WriteSuccess());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, WriteSuccess>> removeBagItem(int bagItemIndex) async {
    try {
      await bagItemsDataSource.removeBagItemData(bagItemIndex);
      return const Right(WriteSuccess());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, WriteSuccess>> updateBagItem(
      BagItemData bagItemData) async {
    try {
      await bagItemsDataSource.setBagItemDataQuantity(
          bagItemData.productVariantId, bagItemData.quantity);
      return const Right(WriteSuccess());
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
        return const Right(OptionsSelections());
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
  Future<Either<Failure, WriteSuccess>> updateSelectedOptionsFields(
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
          productId,
          OptionsSelections(
            selectedOptions: newMap,
            quantity: currentOptionsSelections.quantity,
          ),
        );
        return const Right(WriteSuccess());
      }
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, WriteSuccess>> updateSelectedOptionsQuantity(
      String productId, OptionsSelections newOptionSelection) async {
    try {
      final currentOptionsSelections =
          await optionsSelectionDataSource.getSavedSelectedOptions(productId);
      if (currentOptionsSelections == null) {
        await optionsSelectionDataSource.saveSelectedOptions(
            productId, newOptionSelection);
        return const Right(WriteSuccess());
      } else {
        await optionsSelectionDataSource.saveSelectedOptions(
          productId,
          OptionsSelections(
            selectedOptions: currentOptionsSelections.selectedOptions,
            quantity: newOptionSelection.quantity,
          ),
        );
        return const Right(WriteSuccess());
      }
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, WriteSuccess>> clearBagItems() async {
    try {
      await bagItemsDataSource.clearBagItems();
      return const Right(WriteSuccess());
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
