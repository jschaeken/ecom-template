import 'package:ecom_template/features/shop/data/models/shop_product_model.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopify_flutter/models/src/product/product.dart';

void main() {
  const testShopProductModel = ShopProductModel(
    id: '1',
    title: 'Test Product',
    productType: 'Test Type',
    vendor: 'Test Vendor',
    tags: ['tag1', 'tag2'],
    options: [],
    images: [],
    productVariants: [],
    availableForSale: true,
    createdAt: '',
    updatedAt: '',
    publishedAt: '',
    metafields: [],
    isPopular: false,
  );

  test('should be a subclass of a ShopProduct entity', () async {
    // assert
    expect(testShopProductModel, isA<ShopProduct>());
  });

  group('fromShopifyProductModel', () {
    test(
        'should return a valid ShopProductModel object from the shopify product object',
        () async {
      // arrange
      final product = Product(
        id: '1',
        title: 'Test Product',
        productType: 'Test Type',
        vendor: 'Test Vendor',
        tags: ['tag1', 'tag2'],
        option: [],
        images: [],
        productVariants: [],
        availableForSale: true,
        createdAt: '',
        updatedAt: '',
        publishedAt: '',
        metafields: [],
      );

      // act
      final result = ShopProductModel.fromShopifyProduct(product);
      // assert
      expect(result, testShopProductModel);
    });
  });
}
