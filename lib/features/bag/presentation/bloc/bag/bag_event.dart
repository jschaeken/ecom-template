part of 'bag_bloc.dart';

sealed class BagEvent extends Equatable {
  const BagEvent();

  @override
  List<Object> get props => [];
}

class AddBagItemEvent extends BagEvent {
  final BagItemData bagItemData;

  const AddBagItemEvent({required this.bagItemData});

  @override
  List<Object> get props => [bagItemData];
}

class RemoveBagItemEvent extends BagEvent {
  final int bagItemIndex;

  const RemoveBagItemEvent({required this.bagItemIndex});

  @override
  List<Object> get props => [bagItemIndex];
}

class ClearBagEvent extends BagEvent {}

class GetAllBagItemsEvent extends BagEvent {}

class UpdateBagItemQuantityEvent extends BagEvent {
  final int quantity;
  final BagItem bagItem;

  const UpdateBagItemQuantityEvent(
      {required this.quantity, required this.bagItem});

  @override
  List<Object> get props => [bagItem, quantity];
}
