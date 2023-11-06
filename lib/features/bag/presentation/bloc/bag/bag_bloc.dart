import 'package:bloc/bloc.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/bag/domain/usecases/add_bag_item.dart';
import 'package:ecom_template/features/bag/domain/usecases/get_all_bag_items.dart';
import 'package:ecom_template/features/bag/domain/usecases/remove_bag_item.dart';
import 'package:ecom_template/features/bag/domain/usecases/update_bag_item.dart';
import 'package:equatable/equatable.dart';

part 'bag_event.dart';
part 'bag_state.dart';

class BagBloc extends Bloc<BagEvent, BagState> {
  AddBagItem addBagItem;
  RemoveBagItem removeBagItem;
  GetAllBagItems getAllBagItems;
  UpdateBagItem updateBagItem;

  BagBloc({
    required this.addBagItem,
    required this.removeBagItem,
    required this.getAllBagItems,
    required this.updateBagItem,
  }) : super(BagInitial()) {
    on<BagEvent>((event, emit) async {
      switch (event.runtimeType) {
        case AddBagItemEvent:
          emit(BagLoadingState());
          final bagItem = (event as AddBagItemEvent).bagItem;
          final result = await addBagItem(BagItemParams(bagItem: bagItem));
          await result.fold(
            (failure) {
              emit(BagErrorState(failure: failure));
            },
            (success) async {
              final bagItems = await getAllBagItems(NoParams());
              bagItems.fold(
                (failure) {
                  emit(BagErrorState(failure: failure));
                },
                (bagItems) {
                  if (bagItems.isEmpty) {
                    emit(BagEmptyState());
                  } else {
                    emit(BagLoadedState(bagItems: bagItems));
                  }
                },
              );
            },
          );
          break;
        case RemoveBagItemEvent:
          emit(BagLoadingState());
          final bagItem = (event as RemoveBagItemEvent).bagItem;
          final result = await removeBagItem(BagItemParams(bagItem: bagItem));
          await result.fold(
            (failure) {
              emit(BagErrorState(failure: failure));
            },
            (success) async {
              final bagItems = await getAllBagItems(NoParams());
              bagItems.fold(
                (failure) {
                  emit(BagErrorState(failure: failure));
                },
                (bagItems) {
                  if (bagItems.isEmpty) {
                    emit(BagEmptyState());
                  } else {
                    emit(BagLoadedState(bagItems: bagItems));
                  }
                },
              );
            },
          );
          break;
        case GetAllBagItemsEvent:
          emit(BagLoadingState());
          final result = await getAllBagItems(NoParams());
          result.fold(
            (failure) {
              emit(BagErrorState(failure: failure));
            },
            (bagItems) {
              if (bagItems.isEmpty) {
                emit(BagEmptyState());
              } else {
                emit(BagLoadedState(bagItems: bagItems));
              }
            },
          );
        case UpdateBagItemQuantityEvent:
          emit(BagLoadingState());
          final bagItem = (event as UpdateBagItemQuantityEvent).bagItem;
          final result = await updateBagItem(
              BagItemParams(bagItem: bagItem, quantity: event.quantity));
          await result.fold(
            (failure) {
              emit(BagErrorState(failure: failure));
            },
            (success) async {
              final bagItems = await getAllBagItems(NoParams());
              bagItems.fold(
                (failure) {
                  emit(BagErrorState(failure: failure));
                },
                (bagItems) {
                  if (bagItems.isEmpty) {
                    emit(BagEmptyState());
                  } else {
                    emit(BagLoadedState(bagItems: bagItems));
                  }
                },
              );
            },
          );
      }
    });
  }
}