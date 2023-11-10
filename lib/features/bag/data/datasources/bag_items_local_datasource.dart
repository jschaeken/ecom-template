// ignore_for_file: constant_identifier_names

import 'package:ecom_template/core/error/exceptions.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item_data.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

const BOX_NAME = 'bag';

abstract class BagItemsLocalDataSource {
  /// Gets the cached List<[BagItemData]> from the local storage
  Future<List<BagItemData>> getAllLocalBagItemData();

  /// Adds a new [BagItemData] to the local storage
  Future<WriteSuccess> addBagItemData(BagItemData bagItem);

  /// Removes a [BagItemData] from the local storage
  Future<WriteSuccess> removeBagItemData(String id);

  /// Adds a [BagItemData] in the local storage with the same uniqueKey and sums the new quantity to the existing quantity
  Future<WriteSuccess> addBagItemDataQuantity(String entryId, int quantity);

  /// Updates a [BagItemData] in the local storage with the same uniqueKey and sets the quantity
  Future<WriteSuccess> setBagItemDataQuantity(String entryId, int quantity);
}

class BagItemsLocalDataSourceImpl implements BagItemsLocalDataSource {
  final HiveInterface interface;

  BagItemsLocalDataSourceImpl({required this.interface});

  @override
  Future<List<BagItemData>> getAllLocalBagItemData() async {
    final hiveBox = await _getOpenBox();
    final bagItems = hiveBox.values.toList();
    return bagItems;
  }

  @override
  Future<WriteSuccess> addBagItemData(BagItemData bagItemData) async {
    try {
      final hiveBox = await _getOpenBox();
      debugPrint('hiveBox: $hiveBox');
      if (hiveBox.containsKey(bagItemData.productVariantId)) {
        addBagItemDataQuantity(
            bagItemData.productVariantId, bagItemData.quantity);
        return const WriteSuccess();
      } else {
        debugPrint('adding new bag item: $bagItemData');
        await hiveBox.put(bagItemData.productVariantId, bagItemData);
        return const WriteSuccess();
      }
    } catch (e) {
      debugPrint(e.toString());
      throw CacheException();
    }
  }

  @override
  Future<WriteSuccess> removeBagItemData(String id) async {
    try {
      final hiveBox = await _getOpenBox();
      if (hiveBox.containsKey(id)) {
        await hiveBox.delete(id);
        return const WriteSuccess();
      } else {
        throw Exception('BagItem not found');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw CacheException();
    }
  }

  @override
  Future<WriteSuccess> addBagItemDataQuantity(
      String entryId, int quantity) async {
    try {
      final hiveBox = await _getOpenBox();
      final BagItemData existingData = hiveBox.get(entryId)!;
      BagItemData updated = BagItemData(
        parentProductId: existingData.parentProductId,
        quantity: existingData.quantity + quantity,
        productVariantId: existingData.productVariantId,
      );
      await hiveBox.put(entryId, updated);
      return const WriteSuccess();
    } catch (e) {
      debugPrint(e.toString());
      throw CacheException();
    }
  }

  @override
  Future<WriteSuccess> setBagItemDataQuantity(
      String entryId, int quantity) async {
    try {
      final hiveBox = await _getOpenBox();
      final BagItemData existingData = hiveBox.get(entryId)!;
      BagItemData updated = BagItemData(
        parentProductId: existingData.parentProductId,
        quantity: quantity,
        productVariantId: existingData.productVariantId,
      );
      await hiveBox.put(entryId, updated);
      return const WriteSuccess();
    } catch (e) {
      debugPrint(e.toString());
      throw CacheException();
    }
  }

  Future<Box<BagItemData>> _getOpenBox() async {
    try {
      late final Box<BagItemData> hiveBox;
      hiveBox = await interface.openBox<BagItemData>(BOX_NAME);
      return hiveBox;
    } catch (e) {
      debugPrint('getOpenBox error: ${e.toString()}');
      throw CacheException();
    }
  }
}
