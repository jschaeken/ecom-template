part of 'shopping_bloc.dart';

sealed class ShoppingEvent extends Equatable {
  const ShoppingEvent();

  @override
  List<Object> get props => [];
}

final class GetAllProductsEvent extends ShoppingEvent {
  const GetAllProductsEvent();
}

final class GetProductByIdEvent extends ShoppingEvent {
  final String id;

  const GetProductByIdEvent({required this.id});

  @override
  List<Object> get props => [id];
}

final class GetProductsByCollectionIdEvent extends ShoppingEvent {
  final String id;

  const GetProductsByCollectionIdEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class GetProductsByListIdsEvent extends ShoppingEvent {
  final List<String> ids;

  const GetProductsByListIdsEvent({required this.ids});

  @override
  List<Object> get props => [ids];
}
