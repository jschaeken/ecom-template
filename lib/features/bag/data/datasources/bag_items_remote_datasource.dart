import 'package:shopify_flutter/shopify/src/shopify_store.dart';

abstract class BagItemsRemoteDataSource {}

class BagItemsRemoteDataSourceImpl implements BagItemsRemoteDataSource {
  late final ShopifyStore shopifyStore;

  /// The [shopifyStore] is a required parameter.
  BagItemsRemoteDataSourceImpl({required this.shopifyStore});
}
