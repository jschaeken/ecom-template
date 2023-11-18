import 'package:ecom_template/features/shop/data/models/shop_product_model.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product_image.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product_selected_option.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product_unit_price_measurement.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopify_flutter/models/src/product/associated_collections/associated_collections.dart';
import 'package:shopify_flutter/models/src/product/metafield/metafield.dart';
import 'package:shopify_flutter/models/src/product/option/option.dart';
import 'package:shopify_flutter/models/src/product/price_v_2/price_v_2.dart';
import 'package:shopify_flutter/models/src/product/product.dart';
import 'package:shopify_flutter/models/src/product/product_variant/product_variant.dart';
import 'package:shopify_flutter/models/src/product/selected_option/selected_option.dart';
import 'package:shopify_flutter/models/src/product/shopify_image/shopify_image.dart';
import 'package:shopify_flutter/models/src/product/unit_price_measurement/unit_price_measurement.dart';

void main() {
  const testShopProductModel = ShopProductModel(
    options: [
      ShopProductOption(
        id: '1',
        name: 'Test Option',
        values: ['value1', 'value2'],
      )
    ],
    id: '1',
    title: 'Test Product',
    productType: 'Test Type',
    vendor: 'Test Vendor',
    tags: ['tag1', 'tag2'],
    images: [
      ShopProductImage(
        altText: 'altText',
        id: 'id',
        originalSrc: 'originalSrc',
      )
    ],
    productVariants: [
      ShopProductProductVariant(
        unitPriceMeasurement: ShopProductUnitPriceMeasurement(
          measuredType: 'measuredType',
          quantityUnit: ' quantityUnit',
          quantityValue: 1.5,
          referenceUnit: 'referenceUnit',
          referenceValue: 1,
        ),
        unitPrice: Price(amount: 200, currencyCode: 'USD'),
        selectedOptions: [
          ShopProductSelectedOption(name: 'name', value: 'value'),
        ],
        image: ShopProductImage(
          altText: 'altText',
          id: 'id',
          originalSrc: 'originalSrc',
        ),
        compareAtPrice: Price(amount: 200, currencyCode: 'USD'),
        availableForSale: true,
        id: 'id',
        price: Price(amount: 200, currencyCode: 'USD'),
        quantityAvailable: 10,
        requiresShipping: true,
        sku: '123456789',
        title: 'prodVariantTitle',
        weight: 200,
        weightUnit: 'kg',
      )
    ],
    availableForSale: true,
    createdAt: 'a',
    updatedAt: 'b',
    publishedAt: 'c',
    metafields: [
      ShopProductMetafield(
        description: 'description',
        id: 'id',
        key: 'key',
        namespace: 'namespace',
        value: 'value',
        valueType: 'valueType',
      )
    ],
    collectionList: [
      ShopProductAssociatedCollections(
        id: 'id1',
        title: 'title1',
        description: 'description1',
        updatedAt: 'updatedAt1',
      ),
      ShopProductAssociatedCollections(
        id: 'id2',
        title: 'title2',
        description: 'description2',
        updatedAt: 'updatedAt2',
      ),
    ],
    cursor: 'd',
    description: 'e',
    descriptionHtml: 'f',
    handle: 'g',
    onlineStoreUrl: 'h',
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
        option: [
          Option(
            id: '1',
            name: 'Test Option',
            values: ['value1', 'value2'],
          )
        ],
        images: [
          ShopifyImage(
            altText: 'altText',
            id: 'id',
            originalSrc: 'originalSrc',
          )
        ],
        productVariants: [
          ProductVariant(
            unitPriceMeasurement: UnitPriceMeasurement(
              measuredType: 'measuredType',
              quantityUnit: ' quantityUnit',
              quantityValue: 1.5,
              referenceUnit: 'referenceUnit',
              referenceValue: 1,
            ),
            unitPrice: PriceV2(amount: 200, currencyCode: 'USD'),
            selectedOptions: [
              SelectedOption(name: 'name', value: 'value'),
            ],
            image: ShopifyImage(
              altText: 'altText',
              id: 'id',
              originalSrc: 'originalSrc',
            ),
            compareAtPrice: PriceV2(amount: 200, currencyCode: 'USD'),
            availableForSale: true,
            id: 'id',
            price: PriceV2(amount: 200, currencyCode: 'USD'),
            quantityAvailable: 10,
            requiresShipping: true,
            sku: '123456789',
            title: 'prodVariantTitle',
            weight: 200,
            weightUnit: 'kg',
          )
        ],
        availableForSale: true,
        createdAt: 'a',
        updatedAt: 'b',
        publishedAt: 'c',
        metafields: [
          Metafield(
            description: 'description',
            id: 'id',
            key: 'key',
            namespace: 'namespace',
            value: 'value',
            valueType: 'valueType',
          )
        ],
        collectionList: [
          AssociatedCollections(
            id: 'id1',
            title: 'title1',
            description: 'description1',
            updatedAt: 'updatedAt1',
          ),
          AssociatedCollections(
            id: 'id2',
            title: 'title2',
            description: 'description2',
            updatedAt: 'updatedAt2',
          ),
        ],
        cursor: 'd',
        description: 'e',
        descriptionHtml: 'f',
        handle: 'g',
        onlineStoreUrl: 'h',
      );

      // act
      final result = ShopProductModel.fromShopifyProduct(product);
      // assert
      expect(result, testShopProductModel);
    });
  });
}
