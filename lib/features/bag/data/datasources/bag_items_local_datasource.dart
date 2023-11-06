import 'package:ecom_template/core/error/exceptions.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

const BOX_NAME = 'bag';

abstract class BagItemsLocalDataSource {
  /// Gets the cached List<[BagItem]> from the local storage
  Future<List<BagItem>> getAllBagItems();

  /// Adds a [BagItem] to the local storage
  Future<WriteSuccess> addBagItem(BagItem bagItem);

  /// Removes a [BagItem] from the local storage
  Future<WriteSuccess> removeBagItem(String id);

  /// Adds a [BagItem] in the local storage with the same uniqueKey and adds the quantity to the existing quantity
  Future<WriteSuccess> addBagItemQuantity(String entryId, BagItem bagItem);

  /// Updates a [BagItem] in the local storage with the same uniqueKey and sets the quantity
  Future<WriteSuccess> setBagItemQuantity(int quantity, BagItem bagItem);
}

class BagItemsLocalDataSourceImpl implements BagItemsLocalDataSource {
  final HiveInterface interface;

  BagItemsLocalDataSourceImpl({required this.interface});

  @override
  Future<List<BagItem>> getAllBagItems() async {
    final hiveBox = await _getOpenBox();
    final bagItems = hiveBox.values.toList();
    return bagItems;
  }

  @override
  Future<WriteSuccess> addBagItem(BagItem bagItem) async {
    try {
      final hiveBox = await _getOpenBox();
      if (hiveBox.containsKey(bagItem.uniqueKey)) {
        addBagItemQuantity(bagItem.uniqueKey, bagItem);
        return const WriteSuccess();
      }
      await hiveBox.put(bagItem.uniqueKey, bagItem);
      return const WriteSuccess();
    } catch (e) {
      print(e.toString());
      throw CacheException();
    }
  }

  @override
  Future<WriteSuccess> removeBagItem(String id) async {
    try {
      final hiveBox = await _getOpenBox();
      if (hiveBox.containsKey(id)) {
        await hiveBox.delete(id);
        return const WriteSuccess();
      } else {
        throw Exception('BagItem not found');
      }
    } catch (e) {
      print(e.toString());
      throw CacheException();
    }
  }

  @override
  Future<WriteSuccess> addBagItemQuantity(
      String entryId, BagItem bagItem) async {
    try {
      final hiveBox = await _getOpenBox();
      final BagItem existingItem = hiveBox.get(bagItem.uniqueKey)!;
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + bagItem.quantity,
      );
      debugPrint('updatedItem quantity: ${updatedItem.quantity}');
      await hiveBox.put(bagItem.uniqueKey, updatedItem);
      return const WriteSuccess();
    } catch (e) {
      print(e.toString());
      throw CacheException();
    }
  }

  @override
  Future<WriteSuccess> setBagItemQuantity(int quantity, BagItem bagItem) async {
    try {
      final hiveBox = await _getOpenBox();
      final updatedItem = bagItem.copyWith(quantity: quantity);
      await hiveBox.put(bagItem.uniqueKey, updatedItem);
      return const WriteSuccess();
    } catch (e) {
      print(e.toString());
      throw CacheException();
    }
  }

  Future<Box<BagItem>> _getOpenBox() async {
    try {
      late final Box<BagItem> hiveBox;
      hiveBox = await interface.openBox(BOX_NAME);
      return hiveBox;
    } catch (e) {
      throw CacheException();
    }
  }
}
