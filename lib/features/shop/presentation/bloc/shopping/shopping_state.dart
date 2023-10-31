part of 'shopping_bloc.dart';

sealed class ShoppingState extends Equatable {
  const ShoppingState();

  @override
  List<Object> get props => [];
}

final class ShoppingInitial extends ShoppingState {}

final class ShoppingLoading extends ShoppingState {}

final class ShoppingError extends ShoppingState {
  final String message;

  const ShoppingError({required this.message});

  @override
  List<Object> get props => [message];
}

final class ShoppingLoaded extends ShoppingState {
  final List<ShopProduct> products;

  const ShoppingLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

final class ShoppingLoadedById extends ShoppingState {
  final ShopProduct product;

  const ShoppingLoadedById({required this.product});

  @override
  List<Object> get props => [product];
}
