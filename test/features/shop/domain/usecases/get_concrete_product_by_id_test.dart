// ignore_for_file: unused_import

import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:ecom_template/features/shop/domain/repositories/product_repository.dart';
import 'package:ecom_template/features/shop/domain/usecases/get_concrete_product_by_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopify_flutter/models/src/product/price_v_2/price_v_2.dart';
import 'package:shopify_flutter/models/src/product/product_variant/product_variant.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late GetProductById usecase;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    usecase = GetProductById(repository: mockProductRepository);
  });

  const testId = 'a1b2c3';
  const testProduct = ShopProduct(
    title: 'Test Product',
    availableForSale: true,
    createdAt: '',
    id: '',
    images: [],
    metafields: [],
    options: [],
    productType: '',
    productVariants: [
      ShopProductProductVariant(
        price: Price(amount: '200', currencyCode: 'USD'),
        title: 'title',
        weight: 'weight',
        weightUnit: 'weightUnit',
        availableForSale: true,
        sku: 'sku',
        requiresShipping: true,
        id: 'id',
        quantityAvailable: 1,
      )
    ],
    publishedAt: '',
    tags: [],
    updatedAt: '',
    vendor: '',
  );

  test('should get product by id from the repository', () async {
    // arrange
    when(() => mockProductRepository.getProductById(any()))
        .thenAnswer((invocation) async => const Right(testProduct));

    // act
    final result = await usecase(const Params(id: testId));

    // assert
    expect(result, const Right(testProduct));
    verify(() => mockProductRepository.getProductById(testId));
    verifyNoMoreInteractions(mockProductRepository);
  });
}
