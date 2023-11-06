import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product_image.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product_unit_price_measurement.dart';
import 'package:ecom_template/features/shop/domain/repositories/product_repository.dart';
import 'package:ecom_template/features/shop/domain/usecases/get_all_products_by_collection_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late GetAllProductsByCollectionId usecase;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    usecase = GetAllProductsByCollectionId(repository: mockProductRepository);
  });

  const tId = 'test_id';
  final testProducts = <ShopProduct>[
    const ShopProduct(
      title: 'title',
      id: 'id',
      availableForSale: true,
      createdAt: 'createdAt',
      productVariants: [
        ShopProductProductVariant(
          unitPriceMeasurement: ShopProductUnitPriceMeasurement(
            measuredType: '',
            quantityUnit: ' quantityUnit',
            quantityValue: 1.5,
            referenceUnit: '',
            referenceValue: 1,
          ),
          unitPrice: Price(amount: '200', currencyCode: 'USD'),
          selectedOptions: [],
          image: ShopProductImage(
            altText: 'altText',
            id: 'id',
            originalSrc: 'originalSrc',
          ),
          compareAtPrice: Price(amount: '200', currencyCode: 'USD'),
          weightUnit: '',
          availableForSale: true,
          id: '',
          price: Price(amount: '200', currencyCode: 'USD'),
          quantityAvailable: 10,
          requiresShipping: true,
          sku: '',
          title: '',
          weight: '200kg',
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
    ),
  ];

  test('should get all products from the collection when given its id',
      () async {
    // arrange
    when(() => mockProductRepository.getAllProductsByCollectionId(tId))
        .thenAnswer((invocation) async => Right(testProducts));

    // act
    final result = await usecase(const Params(id: tId));

    // assert
    expect(result, Right(testProducts));
    verify(() => mockProductRepository.getAllProductsByCollectionId(tId));
  });
}
