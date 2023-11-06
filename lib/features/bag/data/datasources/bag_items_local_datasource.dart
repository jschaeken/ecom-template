import 'package:ecom_template/core/error/exceptions.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:hive_flutter/hive_flutter.dart';

const BOX_NAME = 'bag';

abstract class BagItemsLocalDataSource {
  /// Gets the cached List<[BagItem]> from the local storage
  Future<List<BagItem>> getAllBagItems();

  /// Adds a [BagItem] to the local storage
  Future<WriteSuccess> addBagItem(BagItem bagItem);

  /// Removes a [BagItemModel] from the local storage
  Future<WriteSuccess> removeBagItem(String id);

  /// Watches the local storage for changes
  Future<Stream<List<BagItem>>> watchBagItems();
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
      await hiveBox.put(bagItem.id, bagItem);
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
  Future<Stream<List<BagItem>>> watchBagItems() async {
    final hiveBox = await _getOpenBox();
    return hiveBox.watch().map((event) {
      final bagItems = hiveBox.values.toList();
      return bagItems;
    });
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
