import 'package:ecom_template/features/shop/data/models/shop_product_model.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_collection.dart';
import 'package:shopify_flutter/models/src/collection/collection.dart';

class ShopCollectionModel extends ShopCollection {
  const ShopCollectionModel({
    required String id,
    required String title,
    required ShopProducts products,
    final String? description,
    final String? descriptionHtml,
    final String? handle,
    final ShopCollectionImage? image,
    final String? updatedAt,
    final String? cursor,
  }) : super(
          id: id,
          title: title,
          products: products,
          updatedAt: updatedAt,
          description: description,
          descriptionHtml: descriptionHtml,
          handle: handle,
          image: image,
          cursor: cursor,
        );

  static ShopCollectionModel fromShopifyCollection(Collection collection) {
    return ShopCollectionModel(
      id: collection.id.toString(),
      title: collection.title.toString(),
      image: ShopCollectionImage(
        altText: collection.image?.altText,
        id: collection.image?.id,
        originalSrc: collection.image?.originalSrc,
      ),
      products: ShopProducts(
        products: collection.products.productList
            .map((product) => ShopProductModel.fromShopifyProduct(product))
            .toList(),
        hasNextPage: collection.products.hasNextPage,
      ),
      description: collection.description.toString(),
      descriptionHtml: collection.descriptionHtml,
      handle: collection.handle,
      updatedAt: collection.updatedAt,
    );
  }

  @override
  String toString() {
    return 'ShopCollectionModel(id: $id, title: $title, products: $products, description: $description, descriptionHtml: $descriptionHtml, handle: $handle, image: $image, updatedAt: $updatedAt)';
  }
}

class ShopCollectionImage {
  final String? originalSrc;
  final String? altText;
  final String? id;

  const ShopCollectionImage({
    required this.originalSrc,
    required this.altText,
    required this.id,
  });

  @override
  String toString() =>
      'ShopCollectionImage(originalSrc: $originalSrc, altText: $altText, id: $id)';
}
