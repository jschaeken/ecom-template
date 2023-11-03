import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/shop/data/models/shop_collection_model.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_collection.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:ecom_template/features/shop/domain/repositories/product_repository.dart';
import 'package:ecom_template/features/shop/domain/usecases/get_all_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late GetAllCollections usecase;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    usecase = GetAllCollections(mockProductRepository);
  });

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

  final testCollections = <ShopCollection>[
    ShopCollection(
      title: 'title',
      id: 'id',
      description: 'description',
      descriptionHtml: 'descriptionHtml',
      handle: 'handle',
      image: const ShopCollectionImage(
        altText: 'altText',
        id: 'id',
        originalSrc: 'originalSrc',
      ),
      products: ShopProducts(products: testProducts, hasNextPage: true),
      updatedAt: 'updatedAt',
    ),
    ShopCollection(
      title: 'title2',
      id: 'id2',
      description: 'description2',
      descriptionHtml: 'descriptionHtml2',
      handle: 'handle2',
      image: const ShopCollectionImage(
        altText: 'altText2',
        id: 'id2',
        originalSrc: 'originalSrc2',
      ),
      products: ShopProducts(
          products: [...testProducts, ...testProducts], hasNextPage: true),
      updatedAt: 'updatedAt2',
    ),
  ];

  test('should get all collections from the repository', () async {
    // arrange
    when(() => mockProductRepository.getAllCollections())
        .thenAnswer((invocation) async => Right(testCollections));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, Right(testCollections));
    verify(() => mockProductRepository.getAllCollections());
  });
}
