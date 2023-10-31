import 'package:bloc/bloc.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:ecom_template/features/shop/domain/usecases/get_all_products.dart';
import 'package:ecom_template/features/shop/domain/usecases/get_concrete_product_by_id.dart';
import 'package:equatable/equatable.dart';

part 'shopping_event.dart';
part 'shopping_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String UNEXPECTED_FAILURE_MESSAGE = 'Unexpected Error';

class ShoppingBloc extends Bloc<ShoppingEvent, ShoppingState> {
  final GetAllProducts getAllProducts;
  final GetProductById getProductById;

  ShoppingBloc({required this.getAllProducts, required this.getProductById})
      : super(ShoppingInitial()) {
    on<ShoppingEvent>((event, emit) async {
      switch (event.runtimeType) {
        case GetProductByIdEvent:
          emit(ShoppingLoading());
          final productOrFailure = await getProductById(
              Params(id: (event as GetProductByIdEvent).id));
          productOrFailure.fold(
            (failure) {
              emit(const ShoppingError(message: SERVER_FAILURE_MESSAGE));
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
              emit(const ShoppingError(message: SERVER_FAILURE_MESSAGE));
            },
            (products) {
              emit(ShoppingLoaded(products: products));
            },
          );
          break;
        default:
          emit(const ShoppingError(message: UNEXPECTED_FAILURE_MESSAGE));
      }
    });
  }
}