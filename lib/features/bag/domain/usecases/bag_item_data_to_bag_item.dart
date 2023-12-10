import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/exceptions.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item_data.dart';
import 'package:ecom_template/features/shop/data/datasources/product_remote_datasource.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:ecom_template/features/shop/domain/repositories/product_repository.dart';

class BagItemDataToBagItem extends UseCase<BagItem, BagItemDataParams> {
  final ProductRepository repository;

  BagItemDataToBagItem({
    required this.repository,
  });

  @override
  Future<Either<Failure, BagItem>> call(BagItemDataParams params) async {
    // Get product from remote
    try {
      final result =
          await repository.getProductById(params.bagItemData.parentProductId);
      return result.fold(
        (l) => Left(l),
        (product) {
          ShopProductProductVariant selectedVariant = product.productVariants
              .firstWhere((element) =>
                  element.id == params.bagItemData.productVariantId);
          return Right(
            BagItem.fromShopProductVariant(
              parentProductTitle: product.title,
              productVariant: selectedVariant,
              quantity: params.bagItemData.quantity,
              parentProductId: params.bagItemData.parentProductId,
            ),
          );
        },
      );
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
    // Get the saved product variant from the ShopProduct
  }
}

class BagItemDataParams extends Params {
  final BagItemData bagItemData;

  const BagItemDataParams({
    required this.bagItemData,
    required super.id,
  });

  @override
  List<Object?> get props => [bagItemData];
}
