// ignore_for_file: unused_import

import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:ecom_template/features/shop/domain/repositories/product_repository.dart';
import 'package:ecom_template/features/shop/domain/usecases/get_all_products.dart';
import 'package:ecom_template/features/shop/domain/usecases/get_concrete_product_by_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopify_flutter/models/src/product/price_v_2/price_v_2.dart';
import 'package:shopify_flutter/models/src/product/product_variant/product_variant.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late GetAllProducts usecase;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    usecase = GetAllProducts(mockProductRepository);
  });

  test('should get all products from the repository', () async {
    // arrange
    when(() => mockProductRepository.getFullProducts())
        .thenAnswer((invocation) async => const Right([]));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, const Right(<ShopProduct>[]));
    verify(() => mockProductRepository.getFullProducts());
    verifyNoMoreInteractions(mockProductRepository);
  });
}
