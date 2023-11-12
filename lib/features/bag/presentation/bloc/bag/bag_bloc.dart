import 'package:bloc/bloc.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item_data.dart';
import 'package:ecom_template/features/bag/domain/usecases/add_bag_item.dart';
import 'package:ecom_template/features/bag/domain/usecases/get_all_bag_items.dart';
import 'package:ecom_template/features/bag/domain/usecases/remove_bag_item.dart';
import 'package:ecom_template/features/bag/domain/usecases/update_bag_item.dart';
import 'package:ecom_template/features/bag/domain/usecases/verify_incomplete_bag_info.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

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
          final incompleteBagItem = (event as AddBagItemEvent).bagItem;
          final verifiedResult =
              await verifyIncompleteBagItem(incompleteBagItem);
          await verifiedResult.fold(
            (failure) {
              emit(BagErrorState(failure: failure));
            },
            (bagItemData) async {
              //////////////////////////////
              //    Adding Item to Bag    //
              //////////////////////////////
              final result = await addBagItem(bagItemData);
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
                        emit(BagLoadedAddedState(bagItems: bagItems));
                      }
                    },
                  );
                },
              );
              debugPrint('bagItemData: $bagItemData');
            },
          );
          break;
        case RemoveBagItemEvent:
          emit(BagLoadingState());
          final bagItem = (event as RemoveBagItemEvent).bagItem;
          final bagItemData = BagItemData(
              parentProductId: bagItem.parentProductId,
              productVariantId: bagItem.id,
              quantity: bagItem.quantity);
          final result = await removeBagItem(bagItemData);
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
                    emit(BagLoadedRemovedState(bagItems: bagItems));
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
          final newQuantity = event.quantity;
          final bagItemData = BagItemData(
            parentProductId: bagItem.parentProductId,
            productVariantId: bagItem.id,
            quantity: newQuantity,
          );
          final result = await updateBagItem(bagItemData);
          await result.fold(
            (failure) {
              emit(BagErrorState(failure: failure));
            },
            (success) async {
              final res = await getAllBagItems(NoParams());

              res.fold(
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
