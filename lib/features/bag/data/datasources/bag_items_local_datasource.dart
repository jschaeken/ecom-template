// ignore_for_file: constant_identifier_names
import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item_data.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class BagItemsLocalDataSource {
  /// Gets the cached List<[BagItemData]> from the local storage
  Future<List<BagItemData>> getAllLocalBagItemData();

  /// Adds a new [BagItemData] to the local storage
  Future<void> addBagItemData(BagItemData bagItem);

  /// Removes a [BagItemData] from the local storage
  Future<void> removeBagItemData(String id);

  /// Adds a [BagItemData] in the local storage with the same uniqueKey and sums the new quantity to the existing quantity
  Future<void> addBagItemDataQuantity(String entryId, int quantity);

  /// Updates a [BagItemData] in the local storage with the same uniqueKey and sets the quantity
  Future<void> setBagItemDataQuantity(String entryId, int quantity);

  /// Clears all the [BagItemData] from the local storage
  Future<void> clearBagItems();
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
  Future<void> addBagItemData(BagItemData bagItemData) async {
    final hiveBox = await _getOpenBox();
    if (hiveBox.containsKey(bagItemData.productVariantId)) {
      addBagItemDataQuantity(
          bagItemData.productVariantId, bagItemData.quantity);
      return;
    } else {
      await hiveBox.put(bagItemData.productVariantId, bagItemData);
      return;
    }
  }

  @override
  Future<void> removeBagItemData(String id) async {
    final hiveBox = await _getOpenBox();
    if (hiveBox.containsKey(id)) {
      await hiveBox.delete(id);
      return;
    }
  }

  @override
  Future<void> addBagItemDataQuantity(String entryId, int quantity) async {
    final hiveBox = await _getOpenBox();
    final BagItemData existingData = hiveBox.get(entryId)!;
    BagItemData updated = BagItemData(
      parentProductId: existingData.parentProductId,
      quantity: existingData.quantity + quantity,
      productVariantTitle: existingData.productVariantTitle,
      productVariantId: existingData.productVariantId,
      isOutOfStock: existingData.isOutOfStock,
    );
    await hiveBox.put(entryId, updated);
    return;
  }

  @override
  Future<void> setBagItemDataQuantity(String entryId, int quantity) async {
    final hiveBox = await _getOpenBox();
    final BagItemData existingData = hiveBox.get(entryId)!;
    BagItemData updated = BagItemData(
      parentProductId: existingData.parentProductId,
      quantity: quantity,
      productVariantTitle: existingData.productVariantTitle,
      productVariantId: existingData.productVariantId,
      isOutOfStock: existingData.isOutOfStock,
    );
    await hiveBox.put(entryId, updated);
    return;
  }

  @override
  Future<void> clearBagItems() async {
    final hiveBox = await _getOpenBox();
    await hiveBox.clear();
    return;
  }

  Future<Box<BagItemData>> _getOpenBox() async {
    late final Box<BagItemData> hiveBox;
    hiveBox = await interface.openBox<BagItemData>(Constants.BAG_BOX_NAME);
    return hiveBox;
  }
}
