import 'package:ecom_template/features/shop/data/models/shop_collection_model.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:equatable/equatable.dart';

class ShopCollection extends Equatable {
  final String id;
  final String title;
  final ShopProducts products;
  final String? description;
  final String? descriptionHtml;
  final String? handle;
  final ShopCollectionImage? image;
  final String? updatedAt;
  final String? cursor;

  const ShopCollection({
    required this.id,
    required this.title,
    required this.products,
    this.description,
    this.descriptionHtml,
    this.handle,
    this.image,
    this.updatedAt,
    this.cursor,
  });

  @override
  List<Object?> get props => [];
}

class ShopProducts extends Equatable {
  final List<ShopProduct> products;
  final bool hasNextPage;

  const ShopProducts({
    required this.products,
    required this.hasNextPage,
  });

  @override
  List<Object?> get props => [products, hasNextPage];
}
