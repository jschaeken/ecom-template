import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:ecom_template/features/shop/domain/repositories/product_repository.dart';
import 'package:ecom_template/features/shop/domain/usecases/get_products_by_substring.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late GetProductsBySubstring getProductsBySubstring;
  late MockProductRepository productRepository;

  setUp(() {
    productRepository = MockProductRepository();
    getProductsBySubstring =
        GetProductsBySubstring(repository: productRepository);
  });

  final tProducts = [
    const ShopProduct(
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
          price: Price(amount: 200, currencyCode: 'USD'),
          title: 'title',
          weight: 100,
          weightUnit: 'kg',
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
    ),
  ];

  group('getAllProductsBySubstring', () {
    test(
      'should return list of products when call to repository with a given string is successful',
      () async {
        // arrange
        when(() => productRepository.getProductsBySubstring(any()))
            .thenAnswer((invocation) async => Right(tProducts));

        // act
        final result =
            await getProductsBySubstring(const Params(id: 'testString'));

        // assert
        expect(result, Right(tProducts));
      },
    );

    test(
      'should return a failure when call to repository with a given string is unsuccessful',
      () async {
        // arrange
        when(() => productRepository.getProductsBySubstring(any()))
            .thenAnswer((invocation) async => Left(ServerFailure()));

        // act
        final result =
            await getProductsBySubstring(const Params(id: 'testString'));

        // assert
        expect(result, Left(ServerFailure()));
      },
    );
  });
}
