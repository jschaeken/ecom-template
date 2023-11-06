import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/exceptions.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/features/bag/data/datasources/bag_items_local_datasource.dart';
import 'package:ecom_template/features/bag/data/repositories/bag_items_repository_impl.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product_image.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBagItemsLocalDataSource extends Mock
    implements BagItemsLocalDataSource {}

late BagItemsRepositoryImpl repository;

void main() {
  late MockBagItemsLocalDataSource mockBagItemsLocalDataSource;

  setUp(() {
    mockBagItemsLocalDataSource = MockBagItemsLocalDataSource();
    repository = BagItemsRepositoryImpl(
      dataSource: mockBagItemsLocalDataSource,
    );
  });

  final testBagItems = [
    const BagItem(
        title: 'title',
        id: '',
        availableForSale: true,
        price: Price(amount: '', currencyCode: 'String'),
        sku: 'sku',
        weight: 'weight',
        weightUnit: 'weightUnit',
        image: ShopProductImage(
          originalSrc: '',
          altText: '',
        ),
        selectedOptions: [],
        requiresShipping: true,
        quantityAvailable: 1,
        quantity: 1,
        parentProductId: 'testParentId'),
  ];

  group('GetAllBagItems', () {
    test('should return list of bag items from the local database', () async {
      // arrange
      when(() => mockBagItemsLocalDataSource.getAllBagItems())
          .thenAnswer((_) async => testBagItems);

      // act
      final result = await repository.getBagItems();

      // assert
      verify(() => mockBagItemsLocalDataSource.getAllBagItems());
      expect(result, equals(Right(testBagItems)));
    });

    test(
        'should return a CacheFailure when the call to local data source is unsuccessful',
        () async {
      // arrange
      when(() => mockBagItemsLocalDataSource.getAllBagItems())
          .thenThrow(CacheException());

      // act
      final result = await repository.getBagItems();

      // assert
      verify(() => mockBagItemsLocalDataSource.getAllBagItems());
      expect(result, equals(Left(CacheFailure())));
    });
  });

  group('addBagItem', () {
    const WriteSuccess writeSuccess = WriteSuccess();

    test('Should add a bag item to the data source', () async {
      // arrange
      when(() => mockBagItemsLocalDataSource.addBagItem(testBagItems[0]))
          .thenAnswer((_) async => writeSuccess);

      // act
      final result = await repository.addBagItem(testBagItems[0]);

      // assert
      verify(() => mockBagItemsLocalDataSource.addBagItem(testBagItems[0]));
      expect(result, equals(const Right(writeSuccess)));
    });

    test(
        'Should return a CacheFailure when the addBagItem call to local data source is unsuccessful',
        () async {
      // arrange
      when(() => mockBagItemsLocalDataSource.addBagItem(testBagItems[0]))
          .thenThrow(CacheException());

      // act
      final result = await repository.addBagItem(testBagItems[0]);

      // assert
      verify(() => mockBagItemsLocalDataSource.addBagItem(testBagItems[0]));
      expect(result, equals(Left(CacheFailure())));
    });
  });

  group('removeBagItem', () {
    const WriteSuccess writeSuccess = WriteSuccess();

    test('Should remove a bag item from the data source', () async {
      // arrange
      when(() => mockBagItemsLocalDataSource.removeBagItem(testBagItems[0].id))
          .thenAnswer((_) async => writeSuccess);

      // act
      final result = await repository.removeBagItem(testBagItems[0].id);

      // assert
      verify(
          () => mockBagItemsLocalDataSource.removeBagItem(testBagItems[0].id));
      expect(result, equals(const Right(writeSuccess)));
    });

    test(
        'Should return a CacheFailure when the removeBagItem call to local data source is unsuccessful',
        () async {
      // arrange
      when(() => mockBagItemsLocalDataSource.removeBagItem(testBagItems[0].id))
          .thenThrow(CacheException());

      // act
      final result = await repository.removeBagItem(testBagItems[0].id);

      // assert
      verify(
          () => mockBagItemsLocalDataSource.removeBagItem(testBagItems[0].id));
      expect(result, equals(Left(CacheFailure())));
    });
  });
}
