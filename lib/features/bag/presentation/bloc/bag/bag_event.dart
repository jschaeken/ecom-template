part of 'bag_bloc.dart';

sealed class BagEvent extends Equatable {
  const BagEvent();

  @override
  List<Object> get props => [];
}

class AddBagItemEvent extends BagEvent {
  final BagItem bagItem;

  const AddBagItemEvent({required this.bagItem});

  @override
  List<Object> get props => [bagItem];
}

class RemoveBagItemEvent extends BagEvent {
  final BagItem bagItem;

  const RemoveBagItemEvent({required this.bagItem});

  @override
  List<Object> get props => [bagItem];
}

class ClearBagEvent extends BagEvent {}

class GetAllBagItemsEvent extends BagEvent {}
