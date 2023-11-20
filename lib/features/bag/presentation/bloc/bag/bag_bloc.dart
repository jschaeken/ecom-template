import 'package:bloc/bloc.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item_data.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_totals.dart';
import 'package:ecom_template/features/bag/domain/usecases/add_bag_item.dart';
import 'package:ecom_template/features/bag/domain/usecases/calculate_bag_totals.dart';
import 'package:ecom_template/features/bag/domain/usecases/get_all_bag_items.dart';
import 'package:ecom_template/features/bag/domain/usecases/remove_bag_item.dart';
import 'package:ecom_template/features/bag/domain/usecases/update_bag_item.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'bag_event.dart';
part 'bag_state.dart';

class BagBloc extends Bloc<BagEvent, BagState> {
  AddBagItem addBagItem;
  RemoveBagItem removeBagItem;
  GetAllBagItems getAllBagItems;
  UpdateBagItem updateBagItem;
  CalculateBagTotals calculateBagTotals;

  BagBloc({
    required this.addBagItem,
    required this.removeBagItem,
    required this.getAllBagItems,
    required this.updateBagItem,
    required this.calculateBagTotals,
  }) : super(BagInitial()) {
    on<BagEvent>((event, emit) async {
      switch (event.runtimeType) {
        case AddBagItemEvent:
          final bagItemData = (event as AddBagItemEvent).bagItemData;
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
              await bagItems.fold(
                (failure) {
                  emit(BagErrorState(failure: failure));
                },
                (bagItems) async {
                  if (bagItems.isEmpty) {
                    emit(BagEmptyState());
                  } else {
                    final totals = await calculateBagTotals(bagItems);
                    totals.fold(
                      (failure) {
                        emit(
                          BagLoadedAddedState(
                            bagItems: bagItems,
                            bagTotals: const BagTotals(),
                          ),
                        );
                      },
                      (totals) {
                        emit(
                          BagLoadedAddedState(
                            bagItems: bagItems,
                            bagTotals: totals,
                          ),
                        );
                      },
                    );
                  }
                },
              );
            },
          );
          debugPrint('bagItemData: $bagItemData');
          break;
        case RemoveBagItemEvent:
          final bagItem = (event as RemoveBagItemEvent).bagItem;
          final bagItemData = BagItemData(
            parentProductId: bagItem.parentProductId,
            productVariantTitle: bagItem.title,
            productVariantId: bagItem.id,
            quantity: bagItem.quantity,
          );
          final result = await removeBagItem(bagItemData);
          await result.fold(
            (failure) {
              emit(BagErrorState(failure: failure));
            },
            (success) async {
              final bagItems = await getAllBagItems(NoParams());
              await bagItems.fold(
                (failure) {
                  emit(BagErrorState(failure: failure));
                },
                (bagItems) async {
                  if (bagItems.isEmpty) {
                    emit(BagEmptyState());
                  } else {
                    final totals = await calculateBagTotals(bagItems);
                    totals.fold(
                      (failure) {
                        emit(
                          BagLoadedAddedState(
                            bagItems: bagItems,
                            bagTotals: const BagTotals(),
                          ),
                        );
                      },
                      (totals) {
                        emit(
                          BagLoadedAddedState(
                            bagItems: bagItems,
                            bagTotals: totals,
                          ),
                        );
                      },
                    );
                  }
                },
              );
            },
          );
          break;
        case GetAllBagItemsEvent:
          // emit(BagLoadingState());
          final bagItems = await getAllBagItems(NoParams());
          await bagItems.fold(
            (failure) {
              emit(BagErrorState(failure: failure));
            },
            (bagItems) async {
              if (bagItems.isEmpty) {
                emit(BagEmptyState());
              } else {
                final totals = await calculateBagTotals(bagItems);
                totals.fold(
                  (failure) {
                    emit(
                      BagLoadedAddedState(
                        bagItems: bagItems,
                        bagTotals: const BagTotals(),
                      ),
                    );
                  },
                  (totals) {
                    emit(
                      BagLoadedAddedState(
                        bagItems: bagItems,
                        bagTotals: totals,
                      ),
                    );
                  },
                );
              }
            },
          );
        case UpdateBagItemQuantityEvent:
          // emit(BagLoadingState());
          final bagItem = (event as UpdateBagItemQuantityEvent).bagItem;
          final newQuantity = event.quantity;
          final bagItemData = BagItemData(
            parentProductId: bagItem.parentProductId,
            productVariantTitle: bagItem.title,
            productVariantId: bagItem.id,
            quantity: newQuantity,
          );
          final result = await updateBagItem(bagItemData);
          await result.fold(
            (failure) {
              emit(BagErrorState(failure: failure));
            },
            (success) async {
              final bagItems = await getAllBagItems(NoParams());
              await bagItems.fold(
                (failure) {
                  emit(BagErrorState(failure: failure));
                },
                (bagItems) async {
                  if (bagItems.isEmpty) {
                    emit(BagEmptyState());
                  } else {
                    final totals = await calculateBagTotals(bagItems);
                    totals.fold(
                      (failure) {
                        emit(
                          BagLoadedAddedState(
                            bagItems: bagItems,
                            bagTotals: const BagTotals(),
                          ),
                        );
                      },
                      (totals) {
                        emit(
                          BagLoadedAddedState(
                            bagItems: bagItems,
                            bagTotals: totals,
                          ),
                        );
                      },
                    );
                  }
                },
              );
            },
          );
      }
    });
  }
}
