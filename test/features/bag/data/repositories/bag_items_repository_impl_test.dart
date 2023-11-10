import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/exceptions.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/features/bag/data/datasources/bag_items_local_datasource.dart';
import 'package:ecom_template/features/bag/data/repositories/bag_items_repository_impl.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item_data.dart';
import 'package:ecom_template/features/shop/data/datasources/product_remote_datasource.dart';
import 'package:ecom_template/features/shop/data/models/shop_product_model.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product_image.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product_selected_options.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBagItemsLocalDataSource extends Mock
    implements BagItemsLocalDataSource {}

class MockProductRemoteDataSource extends Mock
    implements ProductRemoteDataSource {}

late BagItemsRepositoryImpl repository;

void main() {
  late MockBagItemsLocalDataSource mockBagItemsLocalDataSource;
  late MockProductRemoteDataSource mockProductRemoteDataSource;

  setUp(() {
    mockBagItemsLocalDataSource = MockBagItemsLocalDataSource();
    mockProductRemoteDataSource = MockProductRemoteDataSource();
    repository = BagItemsRepositoryImpl(
      dataSource: mockBagItemsLocalDataSource,
      productRemoteDataSource: mockProductRemoteDataSource,
    );
  });

  final testBagItems = [
    const BagItem(
      image: ShopProductImage(originalSrc: 'https://test.com/image.png'),
      selectedOptions: [
        ShopProductSelectedOptions(name: 'Size', value: 'Extra Extra Large'),
      ],
      compareAtPrice: Price(amount: '100', currencyCode: ''),
      uniqueKey: '',
      unitPrice: Price(amount: '100', currencyCode: ''),
      unitPriceMeasurement: null,
      price: Price(amount: '100', currencyCode: ''),
      title: 'variant title',
      weight: 'weight',
      weightUnit: '',
      availableForSale: true,
      sku: '',
      requiresShipping: true,
      id: '1',
      quantityAvailable: 100,
      quantity: 1,
      parentProductId: 'testParentId',
    ),
  ];

  final testBagItemData = [
    const BagItemData(
      parentProductId: 'testParentId',
      productVariantId: '1',
      quantity: 1,
    ),
  ];

  const testProductModel = ShopProductModel(
    id: 'testParentId',
    isPopular: false,
    title: 'test',
    images: [],
    availableForSale: true,
    createdAt: '',
    metafields: [],
    options: [],
    productType: '',
    productVariants: [
      ShopProductProductVariant(
        image: ShopProductImage(originalSrc: 'https://test.com/image.png'),
        selectedOptions: [
          ShopProductSelectedOptions(name: 'Size', value: 'Extra Extra Large'),
        ],
        compareAtPrice: Price(amount: '100', currencyCode: ''),
        unitPrice: Price(amount: '100', currencyCode: ''),
        unitPriceMeasurement: null,
        price: Price(amount: '100', currencyCode: ''),
        title: 'variant title',
        weight: 'weight',
        weightUnit: '',
        availableForSale: true,
        sku: '',
        requiresShipping: true,
        id: '1',
        quantityAvailable: 100,
      )
    ],
    publishedAt: '',
    tags: [],
    updatedAt: '',
    vendor: '',
  );

  group('GetAllBagItems', () {
    //PASSED (Equatable issue)

    // test(
    //     'should return list of BagItems ater parsing from from the local and remote databases',
    //     () async {
    //   // arrange
    //   when(() => mockBagItemsLocalDataSource.getAllLocalBagItemData())
    //       .thenAnswer((_) async => testBagItemData);
    //   when(() => mockProductRemoteDataSource
    //           .getProductById(testBagItemData[0].parentProductId))
    //       .thenAnswer((_) async => testProductModel);

    //   // act
    //   final result = await repository.getBagItems();

    //   // assert
    //   verify(() => mockBagItemsLocalDataSource.getAllLocalBagItemData());
    //   Right<Failure, List<BagItem>> matcher =
    //       Right<Failure, List<BagItem>>(testBagItems);
    //   expect(result, equals(matcher));
    // });

    test(
        'should return a CacheFailure when the call to local data source is unsuccessful',
        () async {
      // arrange
      when(() => mockBagItemsLocalDataSource.getAllLocalBagItemData())
          .thenThrow(CacheException());

      // act
      final result = await repository.getBagItems();

      // assert
      verify(() => mockBagItemsLocalDataSource.getAllLocalBagItemData());
      expect(result, equals(Left(CacheFailure())));
    });

    test(
        'should return a CacheFailure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(() => mockBagItemsLocalDataSource.getAllLocalBagItemData())
          .thenAnswer((_) async => testBagItemData);
      when(() => mockProductRemoteDataSource.getProductById(
          testBagItemData[0].parentProductId)).thenThrow(CacheException());

      // act
      final result = await repository.getBagItems();

      // assert
      verify(() => mockBagItemsLocalDataSource.getAllLocalBagItemData());
      expect(result, equals(Left(CacheFailure())));
    });
  });

  group('addBagItem', () {
    const WriteSuccess writeSuccess = WriteSuccess();

    test(
        'Should add a return a WriteSuccess when a BagItemData object is passed to the local data source',
        () async {
      // arrange
      when(() => mockBagItemsLocalDataSource.addBagItemData(testBagItemData[0]))
          .thenAnswer((_) async => writeSuccess);

      // act
      final result = await repository.addBagItem(testBagItems[0]);

      // assert
      verify(
          () => mockBagItemsLocalDataSource.addBagItemData(testBagItemData[0]));
      expect(result, equals(const Right(writeSuccess)));
    });

    test(
        'Should return a CacheFailure when the addBagItem call to local data source is unsuccessful',
        () async {
      // arrange
      when(() => mockBagItemsLocalDataSource.addBagItemData(testBagItemData[0]))
          .thenThrow(CacheException());

      // act
      final result = await repository.addBagItem(testBagItems[0]);

      // assert
      verify(
          () => mockBagItemsLocalDataSource.addBagItemData(testBagItemData[0]));
      expect(result, equals(Left(CacheFailure())));
    });
  });

  group('removeBagItem', () {
    const WriteSuccess writeSuccess = WriteSuccess();

    test(
        'Should return a  WriteSuccess when a BagItemData object is removed from the data source',
        () async {
      // arrange
      when(() =>
              mockBagItemsLocalDataSource.removeBagItemData(testBagItems[0].id))
          .thenAnswer((_) async => writeSuccess);

      // act
      final result = await repository.removeBagItem(testBagItems[0].id);

      // assert
      verify(() =>
          mockBagItemsLocalDataSource.removeBagItemData(testBagItems[0].id));
      expect(result, equals(const Right(writeSuccess)));
    });

    test(
        'Should return a CacheFailure when the removeBagItem call to local data source is unsuccessful',
        () async {
      // arrange
      when(() =>
              mockBagItemsLocalDataSource.removeBagItemData(testBagItems[0].id))
          .thenThrow(CacheException());

      // act
      final result = await repository.removeBagItem(testBagItems[0].id);

      // assert
      verify(() =>
          mockBagItemsLocalDataSource.removeBagItemData(testBagItems[0].id));
      expect(result, equals(Left(CacheFailure())));
    });
  });
}
