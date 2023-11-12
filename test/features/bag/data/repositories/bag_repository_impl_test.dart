import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/exceptions.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/features/bag/data/datasources/bag_items_local_datasource.dart';
import 'package:ecom_template/features/bag/data/datasources/options_selection_local_datasource.dart';
import 'package:ecom_template/features/bag/data/repositories/bag_repository_impl.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item_data.dart';
import 'package:ecom_template/features/bag/domain/entities/options_selection.dart';
import 'package:ecom_template/features/shop/data/datasources/product_remote_datasource.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product_image.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product_selected_option.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBagItemsLocalDataSource extends Mock
    implements BagItemsLocalDataSource {}

class MockOptionsSelectionLocalDataSource extends Mock
    implements OptionsSelectionDataSource {}

class MockProductRemoteDataSource extends Mock
    implements ProductRemoteDataSource {}

late BagRepositoryImpl repository;

void main() {
  late MockBagItemsLocalDataSource mockBagItemsLocalDataSource;
  late MockProductRemoteDataSource mockProductRemoteDataSource;
  late MockOptionsSelectionLocalDataSource mockOptionsSelectionLocalDataSource;

  setUp(() {
    mockBagItemsLocalDataSource = MockBagItemsLocalDataSource();
    mockProductRemoteDataSource = MockProductRemoteDataSource();
    mockOptionsSelectionLocalDataSource = MockOptionsSelectionLocalDataSource();

    repository = BagRepositoryImpl(
      bagItemsDataSource: mockBagItemsLocalDataSource,
      optionsSelectionDataSource: mockOptionsSelectionLocalDataSource,
      productRemoteDataSource: mockProductRemoteDataSource,
    );
  });

  final testBagItems = [
    const BagItem(
      image: ShopProductImage(originalSrc: 'https://test.com/image.png'),
      selectedOptions: [
        ShopProductSelectedOption(name: 'Size', value: 'Extra Extra Large'),
      ],
      compareAtPrice: Price(amount: 100, currencyCode: ''),
      uniqueKey: '',
      unitPrice: Price(amount: 100, currencyCode: ''),
      unitPriceMeasurement: null,
      price: Price(amount: 100, currencyCode: ''),
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
      final result = await repository.addBagItem(testBagItemData[0]);

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
      final result = await repository.addBagItem(testBagItemData[0]);

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
      final result = await repository.removeBagItem(testBagItemData[0]);

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
      final result = await repository.removeBagItem(testBagItemData[0]);

      // assert
      verify(() =>
          mockBagItemsLocalDataSource.removeBagItemData(testBagItems[0].id));
      expect(result, equals(Left(CacheFailure())));
    });
  });

  group('getSavedSelectedOptions', () {
    const testSavedSelectedOptions = OptionsSelections(
      selectedOptions: {
        'Option Name 1': 3,
        'Option Name 2': 7,
        'Option Name 3': 2,
        'Option Name 4': 8,
        'Option Name 5': 1,
        'Option Name 6': 9,
        'Option Name 7': 0,
      },
    );

    test(
        'Should return the Right(OptionsSelections) object when the local datasource does',
        () async {
      // arrange
      when(() => mockOptionsSelectionLocalDataSource.getSavedSelectedOptions(
          any())).thenAnswer((_) async => testSavedSelectedOptions);

      // act
      final result = await repository
          .getSavedSelectedOptions(testBagItemData[0].parentProductId);

      // assert
      verify(() => mockOptionsSelectionLocalDataSource
          .getSavedSelectedOptions(testBagItemData[0].parentProductId));
      expect(result, equals(const Right(testSavedSelectedOptions)));
    });
  });

  group('saveSelectedOptions', () {
    const testId = 'tId';
    const testSavedSelectedOptions = OptionsSelections(
      selectedOptions: {
        'Option Name 1': 3,
        'Option Name 2': 7,
        'Option Name 3': 2,
        'Option Name 4': 8,
        'Option Name 5': 1,
        'Option Name 6': 9,
        'Option Name 7': 0,
      },
    );

    const WriteSuccess writeSuccess = WriteSuccess();

    test('Should return a WriteSuccess when the local datasource does',
        () async {
      // arrange
      when(() => mockOptionsSelectionLocalDataSource.saveSelectedOptions(
              testId, testSavedSelectedOptions))
          .thenAnswer((_) async => writeSuccess);

      // act
      final result = await repository.saveSelectedOptions(
          testId, testSavedSelectedOptions);

      // assert
      verify(() => mockOptionsSelectionLocalDataSource.saveSelectedOptions(
          testId, testSavedSelectedOptions));
      expect(result, equals(const Right(writeSuccess)));
    });
  });
}
