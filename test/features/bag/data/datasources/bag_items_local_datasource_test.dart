import 'package:ecom_template/core/error/exceptions.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/features/bag/data/datasources/bag_items_local_datasource.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item_data.dart';
import 'package:mocktail/mocktail.dart';
// ignore: unused_import
import 'package:path_provider/path_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MockStorageInterface extends Mock implements HiveInterface {}

class MockHiveBox extends Mock implements Box<BagItemData> {}

void main() async {
  final mockStorageInterface = MockStorageInterface();
  final mockHiveBox = MockHiveBox();
  BagItemsLocalDataSourceImpl? dataSource;

  setUp(() {
    dataSource = BagItemsLocalDataSourceImpl(interface: mockStorageInterface);
  });

  const testBagItemData = BagItemData(
    productVariantId: '1',
    parentProductId: 'testParentId',
    quantity: 1,
  );

  group('getAllBagItems', () {
    test('Should return all entries from HiveBox', () async {
      when(() => mockStorageInterface.isBoxOpen(any())).thenAnswer((_) => true);
      when(() => mockStorageInterface.openBox<BagItemData>(any()))
          .thenAnswer((_) async => mockHiveBox);
      when(() => mockHiveBox.values).thenReturn([testBagItemData]);

      final result = await dataSource!.getAllLocalBagItemData();

      expect(result, equals([testBagItemData]));
    });
  });

  group('addBagItem', () {
    test('Should add a bag item to the HiveBox', () async {
      when(() => mockStorageInterface.isBoxOpen(any())).thenAnswer((_) => true);
      when(() => mockStorageInterface.openBox<BagItemData>(BOX_NAME))
          .thenAnswer((_) async => mockHiveBox);
      when(() => mockHiveBox.containsKey(any())).thenReturn(false);
      when(() => mockHiveBox.put(
              testBagItemData.productVariantId, testBagItemData))
          .thenAnswer((_) async => {});

      final result = await dataSource!.addBagItemData(testBagItemData);

      verify(() =>
          mockHiveBox.put(testBagItemData.productVariantId, testBagItemData));
      expect(result, equals(const WriteSuccess()));
    });
  });

  group('removeBagItem', () {
    const testId = '1';
    test('Should remove a bag item from the HiveBox', () async {
      when(() => mockStorageInterface.isBoxOpen(any())).thenAnswer((_) => true);
      when(() => mockStorageInterface.openBox<BagItemData>(any()))
          .thenAnswer((_) async => mockHiveBox);
      when(() => mockHiveBox.containsKey(testId)).thenReturn(true);
      when(() => mockHiveBox.delete(testId)).thenAnswer((_) async {});

      final result = await dataSource!.removeBagItemData(testId);

      verify(() => mockHiveBox.delete(testId));
      expect(result, equals(const WriteSuccess()));
    });

    test(
        'Should throw a cache error when a bag item is not found in the HiveBox',
        () async {
      when(() => mockStorageInterface.isBoxOpen(any())).thenAnswer((_) => true);
      when(() => mockStorageInterface.openBox<BagItemData>(any()))
          .thenAnswer((_) async => mockHiveBox);
      when(() => mockHiveBox.containsKey(testId)).thenReturn(false);

      final call = dataSource!.removeBagItemData;

      expect(call(testId), throwsA(isA<CacheException>()));
    });
  });
}
