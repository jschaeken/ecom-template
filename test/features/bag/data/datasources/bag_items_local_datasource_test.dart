import 'package:ecom_template/core/error/exceptions.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/features/bag/data/datasources/bag_items_local_datasource.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:mocktail/mocktail.dart';
// ignore: unused_import
import 'package:path_provider/path_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MockStorageInterface extends Mock implements HiveInterface {}

class MockHiveBox extends Mock implements Box<BagItem> {}

void main() async {
  final mockStorageInterface = MockStorageInterface();
  final mockHiveBox = MockHiveBox();
  BagItemsLocalDataSourceImpl? dataSource;

  setUp(() {
    dataSource = BagItemsLocalDataSourceImpl(interface: mockStorageInterface);
  });

  const testBagItem = BagItem(
      id: '1',
      title: 'test',
      image: null,
      price: Price(amount: '100', currencyCode: 'USD'),
      quantity: 0,
      availableForSale: true,
      quantityAvailable: 1,
      requiresShipping: true,
      selectedOptions: [],
      sku: '',
      weight: '',
      weightUnit: '',
      parentProductId: 'testParentId');

  group('getAllBagItems', () {
    test('Should return all entries from HiveBox', () async {
      when(() => mockStorageInterface.isBoxOpen(any())).thenAnswer((_) => true);
      when(() => mockStorageInterface.openBox<BagItem>(any()))
          .thenAnswer((_) async => mockHiveBox);
      when(() => mockHiveBox.values).thenReturn([testBagItem]);

      final result = await dataSource!.getAllBagItems();

      expect(result, equals([testBagItem]));
    });
  });

  group('addBagItem', () {
    test('Should add a bag item to the HiveBox', () async {
      when(() => mockStorageInterface.isBoxOpen(any())).thenAnswer((_) => true);
      when(() => mockStorageInterface.openBox<BagItem>(any()))
          .thenAnswer((_) async => mockHiveBox);
      when(() => mockHiveBox.add(testBagItem)).thenAnswer((_) async => 1);

      final result = await dataSource!.addBagItem(testBagItem);

      verify(() => mockHiveBox.add(testBagItem));
      expect(result, equals(const WriteSuccess()));
    });
  });

  group('removeBagItem', () {
    const testId = '1';
    test('Should remove a bag item from the HiveBox', () async {
      when(() => mockStorageInterface.isBoxOpen(any())).thenAnswer((_) => true);
      when(() => mockStorageInterface.openBox<BagItem>(any()))
          .thenAnswer((_) async => mockHiveBox);
      when(() => mockHiveBox.containsKey(testId)).thenReturn(true);
      when(() => mockHiveBox.delete(testId)).thenAnswer((_) async {});

      final result = await dataSource!.removeBagItem(testId);

      verify(() => mockHiveBox.delete(testId));
      expect(result, equals(const WriteSuccess()));
    });

    test(
        'Should throw a cache error when a bag item is not found in the HiveBox',
        () async {
      when(() => mockStorageInterface.isBoxOpen(any())).thenAnswer((_) => true);
      when(() => mockStorageInterface.openBox<BagItem>(any()))
          .thenAnswer((_) async => mockHiveBox);
      when(() => mockHiveBox.containsKey(testId)).thenReturn(false);

      final call = dataSource!.removeBagItem;

      expect(call(testId), throwsA(isA<CacheException>()));
    });
  });
}
