import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/exceptions.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/network/network_info.dart';
import 'package:ecom_template/features/shop/data/datasources/product_remote_datasource.dart';
import 'package:ecom_template/features/shop/data/models/shop_collection_model.dart';
import 'package:ecom_template/features/shop/data/models/shop_product_model.dart';
import 'package:ecom_template/features/shop/data/repositories/product_repositoty_impl.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_collection.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements ProductRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late ProductRepositoryImplementation repository;

  const testId = 'test_id';
  const testProductModel = ShopProductModel(
    title: 'title',
    id: 'id',
    availableForSale: true,
    createdAt: 'createdAt',
    productVariants: [
      ShopProductProductVariant(
        availableForSale: true,
        id: '',
        price: Price(amount: 200, currencyCode: 'USD'),
        quantityAvailable: 10,
        requiresShipping: true,
        sku: '',
        title: '',
        weight: '200kg',
        weightUnit: '',
      )
    ],
    productType: 'productType',
    publishedAt: 'publishedAt',
    tags: ['tags'],
    updatedAt: 'updatedAt',
    images: [],
    vendor: 'vendor',
    metafields: [],
    options: [],
    isPopular: true,
  );
  ShopProduct testProduct = testProductModel;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ProductRepositoryImplementation(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  group('getAllProducts', () {
    test('should check if the device is online', () async {
      //arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getAllProducts())
          .thenAnswer((invocation) async => []);

      //act
      await repository.getFullProducts();

      //assert
      verify(() => mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return remote data list of products when the call to remote data source is successful',
          () async {
        final List<ShopProductModel> testProductModels = [testProductModel];
        final List<ShopProduct> testProducts = testProductModels;
        //arrange
        when(() => mockRemoteDataSource.getAllProducts())
            .thenAnswer((invocation) async => testProductModels);

        //act
        final result = await repository.getFullProducts();

        //assert
        verify(() => mockRemoteDataSource.getAllProducts());
        expect(result, Right(testProducts));
      });

      test(
          'should return failure when the call to remote data source is unsuccessful',
          () async {
        //arrange
        when(() => mockRemoteDataSource.getAllProducts())
            .thenThrow(ServerException());

        //act
        final result = await repository.getFullProducts();

        //assert
        verify(() => mockRemoteDataSource.getAllProducts());
        expect(result, Left(ServerFailure()));
      });
    });

    runTestsOffline(() {
      test(
          'Should return Internet Connection failure when the device is offline',
          () async {
        //act
        final result = await repository.getFullProducts();

        //assert
        expect(result, Left(InternetConnectionFailure()));
      });
    });
  });

  group('getProductById', () {
    test('should check if the device is online', () async {
      //arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getProductById(testId))
          .thenAnswer((invocation) async => testProductModel);

      //act
      await repository.getProductById(testId);

      //assert
      verify(() => mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'Should return single product entity when call to remote datsource for single product is successful',
          () async {
        //arrange

        when(() => mockRemoteDataSource.getProductById(testId))
            .thenAnswer((_) async => testProductModel);

        //act
        final result = await repository.getProductById(testId);

        //assert
        verify(() => mockRemoteDataSource.getProductById(testId));
        expect(result, Right(testProduct));
      });
    });

    runTestsOffline(() {
      test(
        'Should return internet connection failure when device is offline',
        () async {
          //act
          final result = await repository.getProductById(testId);

          //assert
          expect(result, Left(InternetConnectionFailure()));
        },
      );
    });
  });

  group('getAllProductsFromCollectionById', () {
    test('should check if the device is online', () async {
      //arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getAllProductsByCollectionId(testId))
          .thenAnswer((invocation) async => [testProductModel]);

      //act
      await repository.getAllProductsByCollectionId(testId);

      //assert
      verify(() => mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'Should return list of products when call to remote datsource for list of products is successful',
          () async {
        final List<ShopProductModel> testProductModels = [testProductModel];
        final List<ShopProduct> testProducts = testProductModels;
        //arrange
        when(() => mockRemoteDataSource.getAllProductsByCollectionId(testId))
            .thenAnswer((_) async => testProductModels);

        //act
        final result = await repository.getAllProductsByCollectionId(testId);

        //assert
        verify(() => mockRemoteDataSource.getAllProductsByCollectionId(testId));
        expect(result, Right(testProducts));
      });

      test(
          'Should return a sever failure when the call to the remote datasource is unsuccesful',
          () async {
        //arrange

        when(() => mockRemoteDataSource.getAllProductsByCollectionId(testId))
            .thenThrow(ServerException());

        //act

        final result = await repository.getAllProductsByCollectionId(testId);

        //assert
        verify(() => mockRemoteDataSource.getAllProductsByCollectionId(testId));
        expect(result, Left(ServerFailure()));
      });
    });

    runTestsOffline(() {
      test(
        'Should return internet connection failure when device is offline',
        () async {
          //act
          final result = await repository.getAllProductsByCollectionId(testId);

          //assert
          expect(result, Left(InternetConnectionFailure()));
        },
      );
    });
  });

  group('getAllCollections', () {
    ShopCollectionModel testCollectionModel = const ShopCollectionModel(
      id: 'id',
      title: 'title',
      products: ShopProducts(hasNextPage: false, products: []),
      description: 'test description',
      descriptionHtml: 'test description html',
      handle: 'test handle',
      image: ShopCollectionImage(
        originalSrc: 'test image url',
        altText: 'test alt text',
        id: 'test id',
      ),
      updatedAt: 'test updated at',
    );

    test('should check if the device is online', () async {
      //arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      //act
      await repository.getAllCollections();

      //assert
      verify(() => mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      final List<ShopCollectionModel> testCollectionModels = [
        testCollectionModel
      ];
      final List<ShopCollection> testCollections = testCollectionModels;
      test('Should get all collections from remote data source', () async {
        //arrange
        when(() => mockRemoteDataSource.getAllCollections())
            .thenAnswer((_) async => testCollectionModels);

        //act
        final result = await repository.getAllCollections();

        //assert
        verify(() => mockRemoteDataSource.getAllCollections());
        expect(result, Right(testCollections));
      });
    });

    runTestsOffline(() {
      test(
        'Should return internet connection failure when device is offline',
        () async {
          //act
          final result = await repository.getAllCollections();

          //assert
          expect(result, Left(InternetConnectionFailure()));
        },
      );
    });
  });
}
