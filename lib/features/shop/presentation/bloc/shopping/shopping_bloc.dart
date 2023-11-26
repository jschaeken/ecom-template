import 'package:bloc/bloc.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:ecom_template/features/shop/domain/usecases/get_all_products.dart';
import 'package:ecom_template/features/shop/domain/usecases/get_all_products_by_collection_id.dart';
import 'package:ecom_template/features/shop/domain/usecases/get_concrete_product_by_id.dart';
import 'package:ecom_template/features/shop/domain/usecases/get_products_by_list_ids.dart';
import 'package:equatable/equatable.dart';

part 'shopping_event.dart';
part 'shopping_state.dart';

class ShoppingBloc extends Bloc<ShoppingEvent, ShoppingState> {
  final GetAllProducts getAllProducts;
  final GetProductById getProductById;
  final GetProductsByListIds getProductsByListIds;
  final GetAllProductsByCollectionId getAllProductsByCollectionId;

  ShoppingBloc({
    required this.getAllProducts,
    required this.getProductById,
    required this.getAllProductsByCollectionId,
    required this.getProductsByListIds,
  }) : super(ShoppingInitial()) {
    on<ShoppingEvent>((event, emit) async {
      switch (event.runtimeType) {
        case GetProductByIdEvent:
          emit(ShoppingLoading());
          final productOrFailure = await getProductById(
              Params(id: (event as GetProductByIdEvent).id));
          productOrFailure.fold(
            (failure) {
              emit(ShoppingError(
                  message: mapFailureToErrorMessage(failure),
                  failure: failure));
            },
            (product) {
              emit(ShoppingLoadedById(product: product));
            },
          );
          break;
        case GetAllProductsEvent:
          emit(ShoppingLoading());
          final productsOrFailure = await getAllProducts(NoParams());
          productsOrFailure.fold(
            (failure) {
              emit(
                ShoppingError(
                  message: mapFailureToErrorMessage(failure),
                  failure: failure,
                ),
              );
            },
            (products) {
              emit(ShoppingLoaded(products: products));
            },
          );
          break;
        case GetProductsByCollectionIdEvent:
          emit(ShoppingLoading());
          final productsOrFailure = await getAllProductsByCollectionId(
            Params(id: (event as GetProductsByCollectionIdEvent).id),
          );
          productsOrFailure.fold(
            (failure) {
              emit(
                ShoppingError(
                  message: mapFailureToErrorMessage(failure),
                  failure: failure,
                ),
              );
            },
            (products) {
              emit(
                ShoppingLoaded(products: products),
              );
            },
          );
          break;
        case GetProductsByListIdsEvent:
          event as GetProductsByListIdsEvent;
          final productsOrFailure = await getProductsByListIds(
            ListIdParams(ids: event.ids),
          );
          productsOrFailure.fold(
            (failure) {
              emit(
                ShoppingError(
                  message: mapFailureToErrorMessage(failure),
                  failure: failure,
                ),
              );
            },
            (products) {
              emit(
                ShoppingLoaded(products: products),
              );
            },
          );

          break;
        default:
          emit(ShoppingError(
              message: UNEXPECTED_FAILURE_MESSAGE, failure: UnknownFailure()));
      }
    });
  }
}
