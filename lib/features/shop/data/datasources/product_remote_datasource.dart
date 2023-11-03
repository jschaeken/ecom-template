import 'dart:developer';

import 'package:ecom_template/core/error/exceptions.dart';
import 'package:ecom_template/features/shop/data/models/shop_product_model.dart';
import 'package:shopify_flutter/models/src/product/product.dart';
import 'package:shopify_flutter/shopify/src/shopify_store.dart';

import '../models/shop_collection_model.dart';

abstract class ProductRemoteDataSource {
  /// Calls the shopify_flutter package methods to get all products.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<ShopProductModel>> getAllProducts();

  /// Calls the shopify_flutter package methods to get a product by id.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<ShopProductModel> getProductById(String id);

  /// Calls the shopify_flutter package methods to get all products from a collection by id.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<ShopProductModel>> getAllProductsByCollectionId(String id);

  /// Calls the shopify_flutter package methods to get all Collections
  ///
  /// Throws a [ServerException] for all error codes
  Future<List<ShopCollectionModel>> getAllCollections();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  late final ShopifyStore shopifyStore;

  /// The [shopifyStore] is a required parameter.
  ProductRemoteDataSourceImpl({required this.shopifyStore});

  @override
  Future<List<ShopProductModel>> getAllProducts() async {
    final response = await shopifyStore.getAllProducts();
    return response
        .map((product) => ShopProductModel.fromShopifyProduct(product))
        .toList();
  }

  @override
  Future<ShopProductModel> getProductById(String id) async {
    List<Product>? response = await shopifyStore.getProductsByIds([id]);
    if ((response ?? []).isNotEmpty) {
      return ShopProductModel.fromShopifyProduct(response!.first);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<ShopProductModel>> getAllProductsByCollectionId(String id) async {
    try {
      final response = await shopifyStore.getAllProductsFromCollectionById(id);
      if (response.isEmpty) {
        throw ServerException();
      }
      return response
          .map((product) => ShopProductModel.fromShopifyProduct(product))
          .toList();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<ShopCollectionModel>> getAllCollections() async {
    final response = await shopifyStore.getAllCollections();
    final models = response
        .map((collection) =>
            ShopCollectionModel.fromShopifyCollection(collection))
        .toList();
    log('model: $models');
    return models;
  }
}
