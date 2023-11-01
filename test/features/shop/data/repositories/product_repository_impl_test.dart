import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/exceptions.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/network/network_info.dart';
import 'package:ecom_template/features/shop/data/datasources/product_remote_datasource.dart';
import 'package:ecom_template/features/shop/data/models/shop_product_model.dart';
import 'package:ecom_template/features/shop/data/repositories/product_repositoty_impl.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements ProductRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late ProductRepositoryImplementation repository;

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
      final testResponseModel = <ShopProductModel>[];
      final List<ShopProduct> testResponseEntity = testResponseModel;

      test(
          'should return remote data list of products when the call to remote data source is successful',
          () async {
        //arrange
        when(() => mockRemoteDataSource.getAllProducts())
            .thenAnswer((invocation) async => testResponseModel);

        //act
        final result = await repository.getFullProducts();

        //assert
        verify(() => mockRemoteDataSource.getAllProducts());
        expect(result, Right(testResponseEntity));
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
          price: '\$200',
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
    const ShopProduct testResponseEntity = testProductModel;

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
        expect(result, const Right(testResponseEntity));
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
}
