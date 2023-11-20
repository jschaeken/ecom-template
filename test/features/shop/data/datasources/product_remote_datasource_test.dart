import 'package:ecom_template/core/error/exceptions.dart';
import 'package:ecom_template/features/shop/data/datasources/product_remote_datasource.dart';
import 'package:ecom_template/features/shop/data/models/shop_product_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopify_flutter/models/src/product/product.dart';
import 'package:shopify_flutter/shopify/shopify.dart';

class MockShopifyStore extends Mock implements ShopifyStore {}

void main() {
  late ProductRemoteDataSourceImpl dataSource;
  late MockShopifyStore mockShopifyStore;

  setUp(() {
    mockShopifyStore = MockShopifyStore();
    dataSource = ProductRemoteDataSourceImpl(
      shopifyStore: mockShopifyStore,
    );
  });

  const testId = '1';
  final testProduct = Product(
    id: testId,
    title: 'test',
    images: [],
    availableForSale: true,
    createdAt: '',
    metafields: [],
    option: [],
    productType: '',
    productVariants: [],
    publishedAt: '',
    tags: [],
    updatedAt: '',
    cursor: '',
    description: 'test',
    descriptionHtml: '',
    handle: '',
    onlineStoreUrl: '',
    vendor: '',
    collectionList: [],
  );
  const testProductEntity = ShopProductModel(
    id: testId,
    title: 'test',
    images: [],
    availableForSale: true,
    createdAt: '',
    metafields: [],
    options: [],
    productType: '',
    productVariants: [],
    publishedAt: '',
    tags: [],
    updatedAt: '',
    cursor: '',
    description: 'test',
    descriptionHtml: '',
    handle: '',
    onlineStoreUrl: '',
    vendor: '',
    collectionList: [],
  );

  group('getProductById', () {
    void mockShopifySingleProductSuccess() {
      when(() => mockShopifyStore.getProductsByIds([testId]))
          .thenAnswer((_) async => [testProduct]);
    }

    void mockShopifySingleProductFailure() {
      when(() => mockShopifyStore.getProductsByIds([testId]))
          .thenAnswer((_) async => []);
    }

    test('should call the shopifyStore to get a product by id', () async {
      // arrange
      mockShopifySingleProductSuccess();
      // act
      await dataSource.getProductById(testId);
      // assert
      verify(() => mockShopifyStore.getProductsByIds([testId]));
    });

    test('should return a product when the list of products is not empty',
        () async {
      // arrange
      mockShopifySingleProductSuccess();
      // act
      final result = await dataSource.getProductById(testId);
      // assert
      expect(result, equals(testProductEntity));
    });

    test('should throw a ServerException when the list of products is empty',
        () async {
      // arrange
      mockShopifySingleProductFailure();

      // act
      final call = dataSource.getProductById;

      // assert
      expect(() => call(testId), throwsA(isA<ServerException>()));
    });
  });

  group('getAllProducts', () {
    void mockShopifyFullProductsSuccess() {
      when(() => mockShopifyStore.getAllProducts())
          .thenAnswer((_) async => [testProduct]);
    }

    test('should call the shopifyStore to get all products', () async {
      // arrange
      mockShopifyFullProductsSuccess();
      // act
      await dataSource.getAllProducts();
      // assert
      verify(() => mockShopifyStore.getAllProducts());
    });

    test('should return a list of products', () async {
      // arrange
      mockShopifyFullProductsSuccess();
      // act
      final result = await dataSource.getAllProducts();
      // assert
      expect(result, equals([testProductEntity]));
    });
  });

  group('getProductsBysubstring', () {
    void mockShopifySearchProductsSuccess() {
      when(() => mockShopifyStore.searchProducts('test'))
          .thenAnswer((_) async => [testProduct]);
    }

    test('should call the shopifyStore to get products by substring', () async {
      // arrange
      mockShopifySearchProductsSuccess();
      // act
      await dataSource.getProductsBySubstring('test');
      // assert
      verify(() => mockShopifyStore.searchProducts('test'));
    });

    test('should return a list of products', () async {
      // arrange
      mockShopifySearchProductsSuccess();
      // act
      final result = await dataSource.getProductsBySubstring('test');
      // assert
      expect(result, equals([testProductEntity]));
    });
  });
}
