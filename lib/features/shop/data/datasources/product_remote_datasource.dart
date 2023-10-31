import 'package:ecom_template/core/error/exceptions.dart';
import 'package:ecom_template/features/shop/data/models/shop_product_model.dart';
import 'package:shopify_flutter/models/src/product/product.dart';
import 'package:shopify_flutter/shopify/src/shopify_store.dart';

abstract class ProductRemoteDataSource {
  /// Calls the shopify_flutter package methods to get all products.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<ShopProductModel>> getAllProducts();

  /// Calls the shopify_flutter package methods to get a product by id.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<ShopProductModel> getProductById(String id);
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
}
